## Test environments
* local OS X install, R 3.6.1
* ubuntu 14.04 (on travis-ci), R 3.6.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

--------------------

Nothing was flagged in winbuilder(s) so shld hopefully
work on the CRAN pre-test infra.

There is one live test requiring network connectivbity to 
retrieve a config from speedtest & verify the results.
I can remove that if desired.
