#!/bin/bash

pdf2svg a.pdf a.svg

inkscape test.emf --export-plain-svg=test.svg
