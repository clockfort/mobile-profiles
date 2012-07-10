all: llvm

llvm: profiles.hs HTMLGen.hs Config.hs Backend.hs
	ghc -O2 -pgmlc -pgmlo -optc-ffast-math -optc-O3 -funfolding-use-threshold=16 -dno-debug-output --make profiles.hs

native: profiles.hs HTMLGen.hs Config.hs Backend.hs
	ghc -O2 -optc-ffast-math -optc-O3 -funfolding-use-threshold=16 -dno-debug-output --make profiles.hs

code-profile:
	ghc -rtsopts -prof -fllvm -auto-all -O2 --make profiles.hs

update:
	git pull
	git submodule init
	git submodule update

clean:
	rm -rf *.o *.hi profiles
