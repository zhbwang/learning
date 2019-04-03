#!/bin/bash

cd /Users/wangzhibin/'Nustore Files'/04_LearningData/01_note_md/learning-doc
pwd
gitbook build
cp -r ./_book/* /Users/wangzhibin/12_note_md/learning/
git add .
git commit -m "rebuild"
git push



cd /Users/wangzhibin/12_note_md/learning/
git add .
git commit -m "rebuild"
git push

