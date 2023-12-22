#!/usr/bin/env bash

INSTALL_DIR='/var/lib/homesetup'

HHS_GROUP='homesetup'

HHS_USERS=('jenkins')

# Add the HomeSetup group
if [[ -z $(getent group "${HHS_GROUP}") ]]; then
  echo "==> Adding HomeSetup group"
  groupadd "${HHS_GROUP}"
fi

# Clone/Pull the repository
if [[ -d "${INSTALL_DIR}" ]]; then
  pushd "${INSTALL_DIR}" &>/dev/null || exit 1
  echo "==> Pulling HomeSetup project"
  git pull &>/dev/null
  popd &>/dev/null || exit 1
else
  echo "==> Cloning HomeSetup project"
  git clone https://github.com/yorevs/homesetup.git "${INSTALL_DIR}" &>/dev/null
fi

# Change the group of HomeSetup files
echo "==> Changing the group of HomeSetup files"
chgrp -R "${HHS_GROUP}" "${INSTALL_DIR}"

# Change the group of /temp dir
echo "==> Changing the group of /temp dir"
chgrp -R "${HHS_GROUP}" "${TEMP}"

# Give read permissions to HomeSetup group
echo "==> Giving read permissions to HomeSetup group"
chmod g+r -R "${INSTALL_DIR}"

# Give read permissions to HomeSetup group
echo "==> Giving read permissions to HomeSetup group"
chmod g+r -R "${TEMP}"

# Add users to the HomeSetup group
for usr in "${HHS_USERS[@]}"; do
  echo "==> Adding ${usr} to HomeSetup group"
  usermod -a -G "${HHS_GROUP}" "${usr}"
done
