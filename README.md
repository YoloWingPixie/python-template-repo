[![Continuous Integration](https://github.com/YoloWingPixie/yaptr/actions/workflows/ci.yml/badge.svg)](https://github.com/YoloWingPixie/yaptr/actions/workflows/ci.yml)

# Yaptr
*Yet Another Python Template Repo*

A full featured python template repo with autogenerated docs, Github Action CI, ruff, pytest, and pre-commit already configured.

## Features
  - pytest
  - ruff
  - sphinx
  - pre-commit

## Quickstart
1. Clone the repository for use in Github by clicking the green "Use this template" button at the top of the page

  *or*

  Clicking here: [Use this template](https://github.com/new?template_name=yaptr&template_owner=YoloWingPixie)

  *or if utilizing another git platform*

  Clone the repository:

 ```bash
 git clone git@github.com:YoloWingPixie/yaptr.git new-directory-name
 cd new-directory-name
 ```

  (Replace `new-directory-name` with the desired name of your new project)

2. Run the setup script:

    ```bash
    make setup-all
    ```
    - I tried to make this as cross-platform as possible
    - Windows users must run this command from PowerShell or Windows Terminal
    - This command will install dependencies for both frontend and backend

3. You will be prompted to select a license for your project. Select the desired license and press enter.
  - See [choosealicense.com](https://choosealicense.com/) for more information on licenses.
  - If you are unsure which license you want, recommend selecting `5) Copyright (All Rights Reserved)` for the time being.

4. You will be prompted to delete the `/license` folder since it is no longer necessary.
  - You should also consider removing the `choose-license` script from the `Makefile` so you can continue to use the `make setup-all` command in the future without being prompted to select a license.

5. You will be prompted to run `make reset-sphinx' to reset the sphinx documentation.
