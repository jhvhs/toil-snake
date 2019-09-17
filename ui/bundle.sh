#!/bin/bash
set -eu

[[ -z "${DEBUG:-}" ]] || set -x

main() {
  local app_dir version
  version=${1:-min}
  app_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


  pushd "$app_dir" > /dev/null
    deploy_app "$version"
  popd > /dev/null
}

deploy_app() {
  local app_filename app_min_filename sha1 version deploy_filename
  version="$1"

  sha1=$(shasum <(cat src/*.elm) | awk '{print $1}')
  app_filename="application-${sha1}.js"
  app_min_filename="application-${sha1}.min.js"

  build "$app_filename"

  if [[ "$version" == "min" ]]; then
    compress "$app_filename" "$app_min_filename"
    deploy_filename="$app_min_filename"
  else
    deploy_filename="$app_filename"
  fi

  deploy "$deploy_filename"
  cleanup "$deploy_filename"
}


build() {
  local app_filename
  app_filename="$1"

  elm make src/*.elm --optimize --output="build/${app_filename}"
}

deploy() {
  local deploy_filename
  deploy_filename="$1"

  echo "Deploying [${deploy_filename}]"

  sed s/_APPLICATION_JS_/"$deploy_filename"/ build/index.build.html > ../public/index.html
  mv "build/${deploy_filename}" ../public/
}

cleanup() {
  local deploy_filename
  deploy_filename="$1"

  for f in ../public/application-*.js ./build/application-*.js; do
    if ! [[ "$f" =~ "$deploy_filename"$ ]]; then
      rm "$f"
    fi
  done
}

compress() {
  local app_filename app_min_filename
  app_filename="build/$1"
  app_min_filename="build/$2"

  command -v uglifyjs
  uglifyjs "$app_filename" --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle --output="$app_min_filename"

  echo "Initial size: $(wc -c < "$app_filename" | numfmt --to iec-i --suffix b)  ($app_filename)"
  echo "Minified size:$(wc -c < "$app_min_filename" | numfmt --to iec-i --suffix b) ($app_min_filename)"
  echo "Gzipped size: $(gzip -c < "$app_min_filename" | wc -c | numfmt --to iec-i --suffix b)"
}

main "$@"