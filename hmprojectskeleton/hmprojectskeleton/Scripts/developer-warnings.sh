CRTODOTAG="\/\/ *CR:"
WARNINGPRIORITIES="High|Blocker"
find "${SRCROOT}" \( -name "*.h" -or -name "*.m" -or -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($CRTODOTAG) \[[A-Za-z ]*\| ($WARNINGPRIORITIES)\].*\$" | perl -p -e "s/($CRTODOTAG)/ warning: \$1/"

ERRORTAG="\/\/ *ERROR:"
find "${SRCROOT}" \( -name "*.h" -or -name "*.m" -or -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($ERRORTAG).*\$" | perl -p -e "s/($ERRORTAG)/ error: \$1/"

WARNINGTAG="\/\/ *WARNING:"
find "${SRCROOT}" \( -name "*.h" -or -name "*.m" -or -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($WARNINGTAG).*\$" | perl -p -e "s/($WARNINGTAG)/ warning: \$1/"