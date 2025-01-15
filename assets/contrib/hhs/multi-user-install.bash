#!/usr/bin/env bash

export HHS_GITHUB_URL='https://github.com/yorevs/homesetup'

HHS_GROUP='homesetup'

HHS_USERS=('jenkins')

INSTALL_DIR="${1:-/var/lib/homesetup}"

# Add the HomeSetup group
if [[ -z $(getent group "${HHS_GROUP}") ]]; then
  echo -e "==> Adding HomeSetup group"
  groupadd "${HHS_GROUP}"
fi

# Clone/Pull the repository
if [[ -d "${INSTALL_DIR}" ]]; then
  pushd "${INSTALL_DIR}" &>/dev/null || exit 1
  echo -e "==> Pulling HomeSetup project"
  git pull &>/dev/null
  popd &>/dev/null || exit 1
else
  echo -e "==> Cloning HomeSetup project"
  git clone "${HHS_GITHUB_URL}.git" "${INSTALL_DIR}" &>/dev/null
fi

# Change the group of HomeSetup files
echo -e "==> Changing the group of HomeSetup files"
chgrp -R "${HHS_GROUP}" "${INSTALL_DIR}"

# Change the group of /temp dir
echo -e "==> Changing the group of /temp dir"
chgrp -R "${HHS_GROUP}" "${TEMP}"

# Give read permissions to HomeSetup group
echo -e "==> Giving read permissions to HomeSetup group"
chmod g+r -R "${INSTALL_DIR}"

# Give read permissions to HomeSetup group
echo -e "==> Giving read permissions to HomeSetup group"
chmod g+r -R "${TEMP}"

# Add users to the HomeSetup group
for usr in "${HHS_USERS[@]}"; do
  echo -e "==> Adding ${usr} to HomeSetup group"
  usermod -a -G "${HHS_GROUP}" "${usr}"
done
