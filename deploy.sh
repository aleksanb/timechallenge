#!/usr/bin/env bash
# Executing the following via 'ssh aleksanb@burkow.no -o StrictHostKeyChecking=no -t':
#
echo "-----> Using RVM environment 'ruby 2.3.0'"
if [[ ! -s "$HOME/.rvm/scripts/rvm" ]]; then
  echo "! Ruby Version Manager not found"
  echo "! If RVM is installed, check your :rvm_path setting."
  exit 1
fi

source $HOME/.rvm/scripts/rvm
rvm use "ruby 2.3.0" --create || exit 1
#!/usr/bin/env bash

# Go to the deploy path
cd "/var/www/burkow.no/challenge/" || (
echo "! ERROR: not set up."
echo "The path '/var/www/burkow.no/challenge/' is not accessible on the server."
echo "You may need to run 'mina setup' first."
false
) || exit 15

# Check releases path
if [ ! -d "releases" ]; then
echo "! ERROR: not set up."
echo "The directory 'releases' does not exist on the server."
echo "You may need to run 'mina setup' first."
exit 16
fi

# Check lockfile
if [ -e "deploy.lock" ]; then
echo "! ERROR: another deployment is ongoing."
echo "The file 'deploy.lock' was found."
echo "If no other deployment is ongoing, run 'mina deploy:force_unlock' to delete the file."
exit 17
fi

# Determine $previous_path and other variables
[ -h "current" ] && [ -d "current" ] && previous_path=$(cd "current" >/dev/null && pwd -LP)
build_path="./tmp/build-`date +%s`$RANDOM"
version=$((`cat "/var/www/burkow.no/challenge//last_version" 2>/dev/null`+1))
release_path="releases/$version"

# Sanity check
if [ -e "$build_path" ]; then
echo "! ERROR: Path already exists."
exit 18
fi

# Bootstrap script (in deployer)
(
echo "-----> Creating a temporary build path"
touch "deploy.lock" &&
mkdir -p "$build_path" &&
cd "$build_path" &&
(
  (
  
    if [ ! -d "/var/www/burkow.no/challenge//scm/objects" ]; then
      echo "-----> Cloning the Git repository"
      git clone "git@github.com:aleksanb/timechallenge.git" "/var/www/burkow.no/challenge//scm" --bare
    else
      echo "-----> Fetching new git commits"
      (cd "/var/www/burkow.no/challenge//scm" && git fetch "git@github.com:aleksanb/timechallenge.git" "master:master" --force)
    fi &&
    echo "-----> Using git branch 'master'" &&
    git clone "/var/www/burkow.no/challenge//scm" . --recursive --branch "master" &&
          
          echo "-----> Using this git commit" &&
          echo &&
          git rev-parse HEAD > .mina_git_revision &&
          git --no-pager log --format='%aN (%h):%n> %s' -n 1 &&
          rm -rf .git &&
          echo
  
  ) && (
  
    echo "-----> Symlinking shared paths"
    mkdir -p "." &&
    mkdir -p "./config" &&
    rm -rf "./log" &&
    ln -s "/var/www/burkow.no/challenge//shared/log" "./log" &&
    rm -rf "./config/database.yml" &&
    ln -s "/var/www/burkow.no/challenge//shared/config/database.yml" "./config/database.yml" &&
    rm -rf "./config/local_env.yml" &&
    ln -s "/var/www/burkow.no/challenge//shared/config/local_env.yml" "./config/local_env.yml" &&
    rm -rf "./config/secrets.yml" &&
    ln -s "/var/www/burkow.no/challenge//shared/config/secrets.yml" "./config/secrets.yml"
  
  ) && (
  
    echo "-----> Installing gem dependencies using Bundler"
    mkdir -p "/var/www/burkow.no/challenge//shared/bundle"
    mkdir -p "./vendor"
    ln -s "/var/www/burkow.no/challenge//shared/bundle" "./vendor/bundle"
    bundle install --without development:test --path "./vendor/bundle" --deployment
  
  ) && (
  
    if [ -e "/var/www/burkow.no/challenge//current/db/migrate/" ]; then
    count=`(
          diff -rN "/var/www/burkow.no/challenge//current/db/migrate/" "./db/migrate/" 2>/dev/null
    ) | wc -l`
    
    if [ "$((count))" = "0" ]; then
          echo "-----> DB migrations unchanged; skipping DB migration" &&
      exit
    else
          echo "-----> Migrating database"
    RAILS_ENV="production" bundle exec rake db:migrate
    fi
    else
      echo "-----> Migrating database"
    RAILS_ENV="production" bundle exec rake db:migrate
    fi
  
  ) && (
  
    if [ -e "/var/www/burkow.no/challenge//current/public/assets" ]; then
    count=`(
          diff -rN "/var/www/burkow.no/challenge//current/vendor/assets/" "./vendor/assets/" 2>/dev/null
    diff -rN "/var/www/burkow.no/challenge//current/app/assets/" "./app/assets/" 2>/dev/null
    ) | wc -l`
    
    if [ "$((count))" = "0" ]; then
          echo "-----> Skipping asset precompilation"
    mkdir -p "/var/www/burkow.no/challenge//$build_path/public/assets"
    cp -R "/var/www/burkow.no/challenge//current/public/assets/." "/var/www/burkow.no/challenge//$build_path/public/assets" &&
      exit
    else
          echo "-----> Precompiling asset files"
    RAILS_ENV="production" bundle exec rake assets:precompile RAILS_GROUPS=assets
    fi
    else
      echo "-----> Precompiling asset files"
    RAILS_ENV="production" bundle exec rake assets:precompile RAILS_GROUPS=assets
    fi
  
  )
) &&
echo "-----> Deploy finished"
) &&

#
# Build
(
echo "-----> Building"
echo "-----> Moving build to $release_path"
mv "$build_path" "$release_path" &&
cd "$release_path" &&
(
  true
) &&
echo "-----> Build finished"

) &&

#
# Launching
# Rename to the real release path, then symlink 'current'
(
echo "-----> Launching"
echo "-----> Updating the current symlink" &&
ln -nfs "$release_path" "current"
) &&

# ============================
# === Start up server => (in deployer)
(
echo "-----> Launching"
cd "current"
true
) &&

# ============================
# === Complete & unlock
(
rm -f "deploy.lock"
echo "$version" > "./last_version"
echo "-----> Done. Deployed v$version"
) ||

# ============================
# === Failed deployment
(
echo "! ERROR: Deploy failed."



echo "-----> Cleaning up build"
[ -e "$build_path" ] && (
  rm -rf "$build_path"
)
[ -e "$release_path" ] && (
  echo "Deleting release"
  rm -rf "$release_path"
)
(
  echo "Unlinking current"
  [ -n "$previous_path" ] && ln -nfs "$previous_path" "current"
)

# Unlock
rm -f "deploy.lock"
echo "OK"
exit 19
)
