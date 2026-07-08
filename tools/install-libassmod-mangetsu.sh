set -eu

prefix=${1:-${LIBASSMOD_PREFIX:-"$PWD/libassmod-prefix"}}
repo=${LIBASSMOD_REPO:-https://github.com/amanosatosi/libassmod}
branch=${LIBASSMOD_BRANCH:-mangetsu}
src=${LIBASSMOD_SRC:-"$PWD/libassmod-src"}
build=${LIBASSMOD_BUILD:-"$PWD/libassmod-build"}
default_library=${LIBASSMOD_DEFAULT_LIBRARY:-static}

if [ ! -d "$src/.git" ]; then
    git clone --depth 1 --branch "$branch" "$repo" "$src"
else
    git -C "$src" fetch --depth 1 origin "$branch"
    git -C "$src" checkout -q FETCH_HEAD
fi

case "$build" in
    "$PWD"/*) ;;
    *)
        echo "Refusing to remove build directory outside the current checkout: $build" >&2
        exit 1
        ;;
esac
rm -rf "$build"
meson setup "$build" "$src" \
    --prefix="$prefix" \
    --libdir=lib \
    --default-library="$default_library" \
    ${LIBASSMOD_MESON_ARGS:-}
ninja -C "$build" install
