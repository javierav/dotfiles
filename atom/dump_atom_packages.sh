#!/usr/bin/env bash

apm list --installed --bare | sed '/^$/d' > atom_packages
