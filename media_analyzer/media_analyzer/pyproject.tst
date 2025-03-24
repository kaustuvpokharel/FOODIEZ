[build-system]
requires = ["setuptools >= 76.1.0"]
build-backend = "setuptools.build_meta"

[project]
name = "media-analysis"
version = "1.0.0"

description = """
Analyzing video reels to get recipes
"""

keywords = ["Machinelearning","Media","Analysis"]

dependencies = [
    "opencv-python==4.6.0.66",
    "torch==2.2.2"
]
requires-python = ">=3.9"

readme = {file = "README.md", content-type = "text/markdown"}
authors = [
    {name = "Sidhant Raj Khati",email = "sidhant.raj.khati@gmail.com"}
]

license = { text = "MIT" }

classifiers = [
   "Programming Language :: Python :: 3",
   "Operating System :: OS Independent",
]

[tool.setuptools.packages]
find = {}