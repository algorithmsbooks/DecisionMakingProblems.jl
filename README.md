# DecisionMakingProblems Documentation
This package uses Documenter.jl for documentation. This readme is only for contributers to the package to explain the usage of Documenter.jl

## Editing Documentation
A contributer to the package can update the documentation by making edits to the markdown files in the docs/src directory. After the edits are made please run the make.jl file in the master branch. This will generate a build folder in the docs directory.

Then move the folder to the gh-pages branch and rename the directory as docs so that the GitHub Pages is able to access the html files. Additionally, it is possible to edit the html files directly either to resize images or edit the LaTeX.

That is how one can use Documenter.jl to edit the documentation for this package. 
