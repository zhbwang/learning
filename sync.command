#!/bin/bash

cd /Users/wangzhibin/00_dev_suite/01_dev_workspace/workspace-github/learning-doc
pwd
gitbook build
cp -r ./_book/* /Users/wangzhibin/00_dev_suite/01_dev_workspace/workspace-github/learning/
