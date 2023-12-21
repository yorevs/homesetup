<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Firebase
>
> The ultimate Terminal experience

## Setup

To use firebase along with HomeSetup, you must first to configure your Firebase account.

### Create new account

If you have a Google account but don't have a Firebase account yet, you can create one using your Google credentials.

Access: [https://console.firebase.google.com/](https://console.firebase.google.com/)

1. Create a *new Project* (HomeSetup).
2. Create a Database (in **production mode**):
   - Go to Develop -> Database -> Create Database.
   - Select **Real-time Database**.
   - Navigate to the **Rules** tab.
3. Add the following rule to your HomeSetup **ruleset**.

Visit https://firebase.google.com/docs/database/security to learn more about security rules.

    ```json
    {
      "rules": {
        "homesetup": {
          ...
          "dotfiles": {
            ".read": "false",
            ".write": "false",
            "$uid" : {
                ".read": "true",
                ".write": "true"
              }
            },
          ...
        }
      }
    }
    ```

### Configure account

To configure your Firebase account for use with HomeSetup, follow these steps:

1. Configure the read and write permissions as shown in section [1.3.1.](#create-new-account) of the documentation.
2. Access your account from: [https://console.firebase.google.com/](https://console.firebase.google.com/)
3. Create a service key to **enable read/write access** to your Firebase account:

   - Click on *Authentication* in the left menu, then select *Users*.
   - Obtain your **USER UID** and Identifier (email).
   - Click on the *cogwheel icon* and choose *Project settings*.
   - Go to the *Service accounts* tab.
   - Obtain your **Project ID**.
   - Click on *Generate new private key*.
   - Save the generated file into the **$HHS_DIR** directory (usually ~/.hhs).
   - Rename the file to *<project-id>-firebase-credentials.json*.

   For more details, consult the [Firebase help page](https://console.firebase.google.com/u/1/project/homesetup-37970/settings/serviceaccounts/adminsdk).

4. In a shell, run the command `$ firebase setup` and fill in the setup form as follows:

   ![Firebase Setup](https://iili.io/H8ll1pa.png "Firebase Setup")

You have now successfully configured Firebase for use with HomeSetup. To learn more about using Firebase features,
type in your shell:

`$ firebase help`

### HomeSetup integration

When you first access the firebase feature of HomeSetup, you will be prompted for some details:

[![FirebaseSetup](https://iili.io/H8ll1pa.png)](https://iili.io/H8ll1pa.png)

This information can be acquired at the firebase console:

![FirebaseSetup](https://iili.io/HUCM03x.png)

Once the Firebase integration is set up, you can start leveraging its benefits for storing your dotfiles. Enjoy the
convenience and peace of mind knowing that your configurations are stored securely in Firebase's Realtime Database.

To enhance security, it is recommended to generate a service token that allows HomeSetup to securely connect to your
Firebase account. You can find detailed instructions on how to generate your [Firebase private key here](https://github.com/yorevs/homesetup/blob/master/README.md#firebase-setup).

Once you have completed the configuration of your Firebase Realtime Database and generated the service token, you can
utilize it with HomeSetup to conveniently upload and download your dotfiles. This integration ensures that your
configurations are safely stored and easily accessible whenever needed. For further guidance and assistance with the
setup process, please refer to the provided documentation on the [User's Handbook](https://github.com/yorevs/homesetup/blob/master/docs/handbook/handbook.md)
of HomeSetup.

[![FirebaseUsage](https://asciinema.org/a/585493.svg)](https://asciinema.org/a/585493)
