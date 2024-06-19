# Coins
inspired by [this tweet](https://x.com/littmath/status/1769044719034647001)

> Flip a fair coin 100 times—it gives a sequence of heads (H) and tails (T). For each HH in the sequence of flips, Alice gets a point; for each HT, Bob does, so e.g. for the sequence THHHT Alice gets 2 points and Bob gets 1 point. Who is most likely to win?

To investigate this question we generate all sequences of 0 and 1 for some length N, and then tally up the scores for alice and bob. We notice that bob wins more often than alice.

## Getting Started
### Installing gcc
we use gcc-14 (not apple clang) because it supports openmp
```
brew install gcc
```

### Clean, Build, Run
run the openmp cpu version
```
make clean && make buildc && ./coins-cpu
```

run the metal gpu version
```
make clean && make build-metal && ./coins-metal
```

### Running
```
./coins
```

### Example Output
openmp
```
❯ make buildc && ./coins-cpu
gcc-14 -O3 -fopenmp c/coins.c -o coins-cpu
n=2, time=0.000183, alice wins=1, bob wins=1, draws=2
n=3, time=0.000097, alice wins=2, bob wins=3, draws=3
n=4, time=0.000084, alice wins=4, bob wins=6, draws=6
n=5, time=0.000104, alice wins=10, bob wins=13, draws=9
n=6, time=0.000085, alice wins=21, bob wins=28, draws=15
n=7, time=0.000086, alice wins=42, bob wins=56, draws=30
n=8, time=0.000091, alice wins=89, bob wins=113, draws=54
n=9, time=0.000084, alice wins=184, bob wins=231, draws=97
n=10, time=0.000066, alice wins=371, bob wins=464, draws=189
n=11, time=0.000086, alice wins=758, bob wins=930, draws=360
n=12, time=0.000078, alice wins=1546, bob wins=1875, draws=675
n=13, time=0.000113, alice wins=3122, bob wins=3766, draws=1304
n=14, time=0.000088, alice wins=6315, bob wins=7547, draws=2522
n=15, time=0.000121, alice wins=12782, bob wins=15151, draws=4835
n=16, time=0.000105, alice wins=25780, bob wins=30398, draws=9358
n=17, time=0.000116, alice wins=51962, bob wins=60917, draws=18193
n=18, time=0.000184, alice wins=104759, bob wins=122116, draws=35269
n=19, time=0.000178, alice wins=210934, bob wins=244786, draws=68568
n=20, time=0.000411, alice wins=424404, bob wins=490435, draws=133737
n=21, time=0.000634, alice wins=853806, bob wins=982544, draws=260802
n=22, time=0.001080, alice wins=1716759, bob wins=1968413, draws=509132
n=23, time=0.002155, alice wins=3450158, bob wins=3942649, draws=995801
n=24, time=0.004207, alice wins=6932169, bob wins=7896116, draws=1948931
n=25, time=0.008454, alice wins=13924260, bob wins=15813268, draws=3816904
n=26, time=0.019214, alice wins=27959805, bob wins=31665423, draws=7483636
n=27, time=0.023845, alice wins=56130762, bob wins=63403245, draws=14683721
n=28, time=0.042057, alice wins=112662414, bob wins=126945244, draws=28827798
n=29, time=0.081706, alice wins=226080318, bob wins=254152625, draws=56637969
n=30, time=0.150569, alice wins=453595341, bob wins=508798604, draws=111347879
n=31, time=0.291435, alice wins=909925794, bob wins=1018538560, draws=219019294
n=32, time=0.574287, alice wins=1825052601, bob wins=2038870881, draws=431043814
n=33, time=1.125687, alice wins=3660020992, bob wins=4081149015, draws=848764585
n=34, time=2.282922, alice wins=7339006091, bob wins=8168806568, draws=1672056525
n=35, time=4.588473, alice wins=14714278862, bob wins=16350068706, draws=3295390800
n=36, time=8.958478, alice wins=29497991764, bob wins=32723948523, draws=6497536449
n=37, time=17.845785, alice wins=59129191502, bob wins=65493519976, draws=12816241994
n=38, time=35.906524, alice wins=118514143839, bob wins=131074624997, draws=25289138108
n=39, time=72.465143, alice wins=237519754398, bob wins=262317425785, draws=49918633705
n=40, time=146.329259, alice wins=475985181699, bob wins=524958142500, draws=98568303577
```

metal
```
❯ make build-metal && ./coins-metal
xcrun -sdk macosx metal -c objc/coin_kernel.metal -o coin_kernel.air
xcrun -sdk macosx metallib coin_kernel.air -o coin_kernel.metallib
clang++ -framework Metal -framework Foundation -o coins-metal objc/coins.mm
n=2, time=0.000851, alice wins=1, bob wins=1, draws=2
n=3, time=0.000288, alice wins=2, bob wins=3, draws=3
n=4, time=0.000179, alice wins=4, bob wins=6, draws=6
n=5, time=0.000156, alice wins=10, bob wins=13, draws=9
n=6, time=0.000179, alice wins=21, bob wins=28, draws=15
n=7, time=0.000203, alice wins=42, bob wins=56, draws=30
n=8, time=0.000210, alice wins=89, bob wins=113, draws=54
n=9, time=0.000219, alice wins=184, bob wins=231, draws=97
n=10, time=0.000186, alice wins=371, bob wins=464, draws=189
n=11, time=0.000136, alice wins=758, bob wins=930, draws=360
n=12, time=0.000176, alice wins=1546, bob wins=1875, draws=675
n=13, time=0.000171, alice wins=3122, bob wins=3766, draws=1304
n=14, time=0.000151, alice wins=6315, bob wins=7547, draws=2522
n=15, time=0.000160, alice wins=12782, bob wins=15151, draws=4835
n=16, time=0.000146, alice wins=25780, bob wins=30398, draws=9358
n=17, time=0.000198, alice wins=51962, bob wins=60917, draws=18193
n=18, time=0.000220, alice wins=104759, bob wins=122116, draws=35269
n=19, time=0.000261, alice wins=210934, bob wins=244786, draws=68568
n=20, time=0.000352, alice wins=424404, bob wins=490435, draws=133737
n=21, time=0.000540, alice wins=853806, bob wins=982544, draws=260802
n=22, time=0.000934, alice wins=1716759, bob wins=1968413, draws=509132
n=23, time=0.001657, alice wins=3450158, bob wins=3942649, draws=995801
n=24, time=0.003100, alice wins=6932169, bob wins=7896116, draws=1948931
n=25, time=0.005956, alice wins=13924260, bob wins=15813268, draws=3816904
n=26, time=0.005829, alice wins=27959805, bob wins=31665423, draws=7483636
n=27, time=0.008322, alice wins=56130762, bob wins=63403245, draws=14683721
n=28, time=0.014686, alice wins=112662414, bob wins=126945244, draws=28827798
n=29, time=0.029092, alice wins=226080318, bob wins=254152625, draws=56637969
n=30, time=0.058004, alice wins=453595341, bob wins=508798604, draws=111347879
n=31, time=0.116230, alice wins=909925794, bob wins=1018538560, draws=219019294
n=32, time=0.231535, alice wins=1825052601, bob wins=2038870881, draws=431043814
n=33, time=0.462288, alice wins=3660020992, bob wins=4081149015, draws=848764585
n=34, time=0.924350, alice wins=7339006091, bob wins=8168806568, draws=1672056525
n=35, time=1.848962, alice wins=14714278862, bob wins=16350068706, draws=3295390800
n=36, time=3.697934, alice wins=29497991764, bob wins=32723948523, draws=6497536449
n=37, time=7.392956, alice wins=59129191502, bob wins=65493519976, draws=12816241994
n=38, time=14.786429, alice wins=118514143839, bob wins=131074624997, draws=25289138108
n=39, time=29.597544, alice wins=237519754398, bob wins=262317425785, draws=49918633705
n=40, time=59.325700, alice wins=475985181699, bob wins=524958142500, draws=98568303577
```
