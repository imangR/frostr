## Resubmission
In this version, I have

* updated description in DESCRIPTION
* put single quotes (') around API names in DESCRIPTION (there is no software or package names in the updated description text)
* replaced \donttest{} with \dontrun{} in Rd-files
* updated calls to `httr::GET` to use a specified user agent where it previously used `httr`'s default user agent
* updated documentation text for each `get_*` function

## Test environments
* local Windows  install, R 4.0.2
* local OS X install, R 4.0.2
* local Ubuntu 20.04 LTS install, R 4.0.2

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs. 

## Downstream dependencies
There are no downstream dependencies.
