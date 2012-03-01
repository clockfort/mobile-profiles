all: profiles

profiles: profiles.hi

profiles.hi: profiles.hs
	ghc -O2 -fllvm --make profiles.hs

clean:
	rm -rf *.o *.hi profiles
