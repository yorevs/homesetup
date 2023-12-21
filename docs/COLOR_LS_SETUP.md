<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup ColorLS
>
> The ultimate Terminal experience

## Setup

### macOS Users

If you are a **macOS** user you may have problems installing colorls using the default gem application. If that's the
case you can follow the instructions below to install it:

> Assuming HomeSetup is installed

```bash
brew install ruby
```

Identify lines resembling the examples below:

  If you need to have ruby first in your PATH, run:
  echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> /Users/<your_user>/.bash_profile

Now add the path to you **PATH** using the command below. **_Please do not touch the .bash_profile file_**,

```bash
paths -a /usr/local/opt/ruby/bin
```

### Linux Users

If you are a Linux user, you can install ColorLS following the instructions [here](https://github.com/athityakumar/colorls?tab=readme-ov-file#installation)

## Final result

After properly installed, your new ls will look like this:

<img src="https://user-images.githubusercontent.com/19269206/234581461-1e1fdd90-a362-4cea-ab82-5ca360746be8.png" />

If you wish to use HomeSetup's ls configuration files you can run:

```bash
rm -rf $(dirname $(gem which colorls))/yaml
reload
```

The HomeSetup ls should look like this:

<img src="https://iili.io/JAgg3RR.png" />
