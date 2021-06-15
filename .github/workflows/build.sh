if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
  # these cause a conflict with built webp and libtiff,
  # curl from brew requires zstd, use system curl
  brew remove --ignore-dependencies webp zstd xz libtiff curl
fi

if [[ "$MB_PYTHON_VERSION" == pypy3* ]]; then
  if [[ "$TRAVIS_OS_NAME" != "macos-latest" ]]; then
    MB_ML_VER="2010"
    DOCKER_TEST_IMAGE="multibuild/xenial_$PLAT"
  else
    MB_PYTHON_OSX_VER="10.9"
  fi
fi

echo "::group::Install a virtualenv"
  source ci/multibuild/common_utils.sh
  source ci/multibuild/travis_steps.sh
  python3 -m pip install virtualenv
  before_install
echo "::endgroup::"

echo "::group::Build wheel"
  build_wheel $REPO_DIR $PLAT
  ls -l "${GITHUB_WORKSPACE}/${WHEEL_SDIR}/"
echo "::endgroup::"

if [[ $MACOSX_DEPLOYMENT_TARGET != "11.0" ]]; then
  echo "::group::Test wheel"
    install_run $PLAT
  echo "::endgroup::"
fi