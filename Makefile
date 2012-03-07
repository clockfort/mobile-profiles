all: profiles

profiles: profiles.hi

profiles.hi: profiles.hs HTMLGen.hs Config.hs Backend.hs
	ghc -O2 -fllvm -dno-debug-output --make profiles.hs

code-profile:
	ghc -prof -fllvm -auto-all -O2 --make profiles.hs
update:
	git pull
	git submodule init
	git submodule update

clean:
	rm -rf *.o *.hi profiles
