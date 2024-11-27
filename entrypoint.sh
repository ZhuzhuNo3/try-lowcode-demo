#!/usr/bin/env bash

function env_check(){
    local exit_ var_
    exit_=false
    for var_ in "${@}";do
        if [[ -z "$(eval echo '$'"${var_}")" ]];then
             echo "${var_} is empty."
             exit_=true
        fi
    done
    if $exit_;then
        exit 1
    fi
}

env_check \
  TITLE \
  EDIT_PORT \
  PROJ_PATH \
  PREVIEW_PORT \
  PREVIEW_PATH \
  ENABLE_EDIT \
  ENABLE_PREVIEW

if [ "$EDIT_PORT" = "$PREVIEW_PORT" ]; then
  echo "$EDIT_PORT == $PREVIEW_PORT"
  exit 1;
fi

if [ "$ENABLE_EDIT" = false -a "$ENABLE_PREVIEW" = false ]; then
  echo "edit and preview both disabled"
  exit 1;
fi

function runEdit() {
  cd "$PROJ_PATH"
  if [ "$ENABLE_PREVIEW" != true ]; then
    exec yarn run start --port "$EDIT_PORT"
  fi
  yarn run start --port "$EDIT_PORT" &
}

function runPreview() {
  cd "$PREVIEW_PATH"
  sed -i'' 's/\(<title>\).*\(<\/title>\)/\1'"$TITLE"'\2/' public/preview.html
  exec yarn run start --port "$PREVIEW_PORT"
}

if [ "$ENABLE_EDIT" = true ]; then
  runEdit
fi
if [ "$ENABLE_PREVIEW" = true ]; then
  runPreview
fi

