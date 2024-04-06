#!/usr/bin/env bash

. ./set_gem_variables.sh

target_dir=$1
curr_dir=$PWD

s_gemspec_summary="TODO: Write a short summary, because RubyGems requires one."
s_gemspec_description="TODO: Write a longer description or delete this line."
s_gemspec_homepage="TODO: Put your gem's website or public repo URL here."

s_gemspec_allowed_push_host="TODO: Set to your gem server 'https://example.com'"
s_gemspec_source_code_uri="TODO: Put your gem's public repo URL here."
s_gemspec_changelog_uri="TODO: Put your gem's CHANGELOG.md URL here."

# Ask for user input
read -p "Enter gem's name: " gem_name
read -p "Enter github username: " r_github_username
read -p "Enter gem summary: " r_gemspec_summary
read -p "Enter gem description: " r_gemspec_description

r_gemspec_homepage="https://github.com/$r_github_username/$gem_name/blob/main/README.md"
r_gemspec_allowed_push_host="https://rubygems.org"
r_gemspec_source_code_uri="https://github.com/$r_github_username/$gem_name"
r_gemspec_changelog_uri="https://github.com/$r_github_username/$gem_name/blob/main/CHANGELOG.md"

gemspec_filename="$gem_name.gemspec"
git_uri="git@github.com:${r_github_username}/${gem_name}.git"
spec_filename="spec/${gem_name}_spec.rb"

# Create gem
echo "[$gem_name] Creating the gem."
cd $target_dir
bundle gem $gem_name

# Change into the gem directory
echo "[$gem_name] Copying templates into the gem directory."
cd $curr_dir
cp -R templates $target_dir/$gem_name

echo "[$gem_name] Changing into the gem directory."
cd $target_dir/$gem_name

cp templates/.env.example .env.example
cp templates/.envrc .envrc
cp templates/devshell.toml devshell.toml
cp templates/flake.lock flake.lock
cp templates/flake.nix flake.nix
cp templates/GEM_NAME.rb lib/$gem_name.rb
cp templates/layout.kdl layout.kdl
cp templates/run bin/run
cp templates/taskfile.yml taskfile.yml
cp templates/README.md README.md
rm -rf templates

if validate_input "$gem_name"; then
  set_gem_variables "$gem_name"
fi

sed -i'' -e "s/GEM_NAME/$GEM_NAME/" .env.example
sed -i'' -e "s/GEM_NAME/$GEM_NAME/" .envrc
sed -i'' -e "s/GEM_NAME/$GEM_NAME/" devshell.toml
sed -i'' -e "s/GEM_NAME/$GEM_NAME/" flake.lock
sed -i'' -e "s/GEM_NAME/$GEM_NAME/" flake.nix
sed -i'' -e "s/GEM_NAME/$GEM_NAME/" lib/$gem_name.rb
sed -i'' -e "s/GEM_NAME/$GEM_NAME/" layout.kdl
sed -i'' -e "s/GEM_NAME/$GEM_NAME/" bin/run
sed -i'' -e "s/GEM_NAME/$GEM_NAME/" taskfile.yml

sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" .env.example
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" .envrc
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" devshell.toml
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" flake.lock
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" flake.nix
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" lib/$gem_name.rb
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" layout.kdl
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" bin/run
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" taskfile.yml

sed -i'' -e "s/GEM_NAME/$GEM_NAME/" README.md
sed -i'' -e "s/CAMEL_CASED_NAME/$CAMEL_CASED_NAME/" README.md
sed -i'' -e "s/GEM_USERNAME/$r_github_username/" README.md
sed -i'' -e "s/GEM_SUMMARY/$r_gemspec_summary/" README.md
sed -i'' -e "s/GEM_DESCRIPTION/$r_gemspec_description/" README.md

rm -rf ".env.example-e"
rm -rf ".envrc-e"
rm -rf "devshell.toml-e"
rm -rf "flake.lock-e"
rm -rf "flake.nix-e"
rm -rf "lib/$gem_name.rb-e"
rm -rf "layout.kdl-e"
rm -rf "bin/run-e"
rm -rf "taskfile.yml-e"
rm -rf sig
rm -rf "README.md-e"

echo "[$gem_name] Replacing gemspec summary."
if [[ $s_gemspec_summary != "" && $r_gemspec_summary != "" ]]; then
  sed -i'' -e "s/$s_gemspec_summary/$r_gemspec_summary/" $gemspec_filename
fi

echo "[$gem_name] Replacing gemspec description."
if [[ $s_gemspec_description != "" && $r_gemspec_description != "" ]]; then
  sed -i'' -e "s/$s_gemspec_description/$r_gemspec_description/" $gemspec_filename
fi

echo "[$gem_name] Replacing gemspec homepage."
if [[ $s_gemspec_homepage != "" && $r_gemspec_homepage != "" ]]; then
  sed -i'' -e "s|${s_gemspec_homepage}|${r_gemspec_homepage}|" $gemspec_filename
fi

echo "[$gem_name] Replacing gemspec allowed push host."
if [[ $s_gemspec_allowed_push_host != "" && $r_gemspec_allowed_push_host != "" ]]; then
  sed -i'' -e "s|${s_gemspec_allowed_push_host}|${r_gemspec_allowed_push_host}|" $gemspec_filename
fi

echo "[$gem_name] Replacing gemspec source code uri."
if [[ $s_gemspec_source_code_uri != "" && $r_gemspec_source_code_uri != "" ]]; then
  sed -i'' -e "s|${s_gemspec_source_code_uri}|${r_gemspec_source_code_uri}|" $gemspec_filename
fi

echo "[$gem_name] Replacing gemspec changelog uri."
if [[ $s_gemspec_changelog_uri != "" && $r_gemspec_changelog_uri != "" ]]; then
  sed -i'' -e "s|${s_gemspec_changelog_uri}|${r_gemspec_changelog_uri}|" $gemspec_filename
fi

rm -rf "${gemspec_filename}-e"

# Remove unused spec in spec/$1_spec.rb by deleting line 7-10
echo "[$gem_name] Removing unused spec."
ed -s ${spec_filename} <<EOF
7,10d
w
q
EOF

echo "[$gem_name] Installing bundler gems."
bundle config set --local path 'vendor/bundle'
bundle install

echo "[$gem_name] Adding ruby platform gems."
bundle lock --add-platform ruby

echo "[$gem_name] Adding linux platform gems."
bundle lock --add-platform x86_64-linux

echo "[$gem_name] Adding mac platform gems."
bundle lock --add-platform arm64-darwin-20
bundle lock --add-platform arm64-darwin-21
bundle lock --add-platform arm64-darwin-22
bundle lock --add-platform arm64-darwin-23

# Run tests
echo "[$gem_name] Running the first test."
bundle exec rspec spec

echo "[$gem_name] Logging into Github."
gh auth login

echo "[$gem_name] Creating remote github repo."
gh repo create $gem_name --public

echo "[$gem_name] Pushing gem repo to github."
git add .
git commit -m "[$gem_name] Bundle initial gem files"
git remote add origin $git_uri
git branch -M main
git push -u origin main

echo "[$gem_name] Building gem and pushing to rubygems org."
bundle exec rake release

echo "[$gem_name] Check for any errors above."
echo "[$gem_name] Done."
