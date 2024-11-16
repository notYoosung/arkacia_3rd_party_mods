.PHONY: dist
dist: check
	git archive --format=zip --prefix=extruder/ --output=minetest-extruder.zip HEAD

# We also check that the cdb file is up to date.
# It needs to be committed so that CDB can auto-import/update the mod
.PHONY: check
check:
	luacheck .
	jq --rawfile readme README.md '.long_description=$$readme' cdb-template.json | diff .cdb.json -

.cdb.json: cdb-template.json README.md
	jq --rawfile readme README.md '.long_description=$$readme' cdb-template.json > .cdb.json
