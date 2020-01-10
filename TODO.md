# HomeSetup TODOs and Bugfixes

## TODO

- [ ] Add a deployer system
- [ ] Check INSTALL_DIR and HHS_HOME
- [ ] Improve command helps
- [ ] Add authentication to FB requests and encode the firebase config and add .vault to firebase
- [ ] Update README.MD
- [ ] hhs_aliasdef.bash must be copied instead of linked when installed
- [ ] install.bash might install required tools (ask for it)

## BUGFIX

- [ ] ip-utils.bash 172.17.252.228 is returning taht it's public, but it's private
- [ ] when exists an application or cuntion __hhs_alias is overriding it
- [ ] vault is complaining about some file that does not exist
- [ ] add prefix when using __hhs_alias automatically when a collision occur
- [ ] gba is not erasing branch fetch info (actually is erasing just the line)