# Firebase Setup

To use firebase along with HomeSetup, you must first to configure your Firebase account.

## Create new account

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

## Configure account

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
