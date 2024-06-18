# Coins
inspired by [this tweet](https://x.com/littmath/status/1769044719034647001)

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
n=2, time=0.000195, alice wins=1, bob wins=1, draws=2
n=3, time=0.000099, alice wins=2, bob wins=3, draws=3
n=4, time=0.000093, alice wins=4, bob wins=6, draws=6
n=5, time=0.000097, alice wins=10, bob wins=13, draws=9
n=6, time=0.000108, alice wins=21, bob wins=28, draws=15
n=7, time=0.000092, alice wins=42, bob wins=56, draws=30
n=8, time=0.000090, alice wins=89, bob wins=113, draws=54
n=9, time=0.000098, alice wins=184, bob wins=231, draws=97
n=10, time=0.000102, alice wins=371, bob wins=464, draws=189
n=11, time=0.000091, alice wins=758, bob wins=930, draws=360
n=12, time=0.000091, alice wins=1546, bob wins=1875, draws=675
n=13, time=0.000105, alice wins=3122, bob wins=3766, draws=1304
n=14, time=0.000099, alice wins=6315, bob wins=7547, draws=2522
n=15, time=0.000116, alice wins=12782, bob wins=15151, draws=4835
n=16, time=0.000119, alice wins=25780, bob wins=30398, draws=9358
n=17, time=0.000124, alice wins=51962, bob wins=60917, draws=18193
n=18, time=0.000150, alice wins=104759, bob wins=122116, draws=35269
n=19, time=0.000225, alice wins=210934, bob wins=244786, draws=68568
n=20, time=0.000361, alice wins=424404, bob wins=490435, draws=133737
n=21, time=0.000564, alice wins=853806, bob wins=982544, draws=260802
n=22, time=0.001049, alice wins=1716759, bob wins=1968413, draws=509132
n=23, time=0.002146, alice wins=3450158, bob wins=3942649, draws=995801
n=24, time=0.003600, alice wins=6932169, bob wins=7896116, draws=1948931
n=25, time=0.006237, alice wins=13924260, bob wins=15813268, draws=3816904
n=26, time=0.015375, alice wins=27959805, bob wins=31665423, draws=7483636
n=27, time=0.022542, alice wins=56130762, bob wins=63403245, draws=14683721
n=28, time=0.041474, alice wins=112662414, bob wins=126945244, draws=28827798
n=29, time=0.093517, alice wins=226080318, bob wins=254152625, draws=56637969
n=30, time=0.153734, alice wins=453595341, bob wins=508798604, draws=111347879
n=31, time=0.289734, alice wins=909925794, bob wins=1018538560, draws=219019294
n=32, time=0.597996, alice wins=1825052601, bob wins=2038870881, draws=431043814
n=33, time=1.148989, alice wins=3660020992, bob wins=4081149015, draws=848764585
n=34, time=2.273139, alice wins=7320041984, bob wins=8162298030, draws=1697529170
n=35, time=4.418002, alice wins=14640083968, bob wins=16324596060, draws=3395058340
n=36, time=8.803318, alice wins=29280167936, bob wins=32649192120, draws=6790116680
n=37, time=17.564449, alice wins=58560335872, bob wins=65298384240, draws=13580233360
n=38, time=35.711908, alice wins=117120671744, bob wins=130596768480, draws=27160466720
n=39, time=72.262677, alice wins=234241343488, bob wins=261193536960, draws=54320933440
n=40, time=142.528410, alice wins=468482686976, bob wins=522387073920, draws=108641866880
n=41, time=285.042563, alice wins=936965373952, bob wins=1044774147840, draws=217283733760
```

metal
```
❯ make build-metal && ./coins-metal
xcrun -sdk macosx metal -c objc/coin_kernel.metal -o coin_kernel.air
xcrun -sdk macosx metallib coin_kernel.air -o coin_kernel.metallib
clang++ -framework Metal -framework Foundation -o coins-metal objc/coins.mm
n=2, time=0.000712, alice wins=1, bob wins=1, draws=2
n=3, time=0.000214, alice wins=2, bob wins=3, draws=3
n=4, time=0.000147, alice wins=4, bob wins=6, draws=6
n=5, time=0.000137, alice wins=10, bob wins=13, draws=9
n=6, time=0.000176, alice wins=21, bob wins=28, draws=15
n=7, time=0.000181, alice wins=42, bob wins=56, draws=30
n=8, time=0.000179, alice wins=89, bob wins=113, draws=54
n=9, time=0.000217, alice wins=184, bob wins=231, draws=97
n=10, time=0.000170, alice wins=371, bob wins=464, draws=189
n=11, time=0.000145, alice wins=758, bob wins=930, draws=360
n=12, time=0.000159, alice wins=1546, bob wins=1875, draws=675
n=13, time=0.000158, alice wins=3122, bob wins=3766, draws=1304
n=14, time=0.000211, alice wins=6315, bob wins=7547, draws=2522
n=15, time=0.000145, alice wins=12782, bob wins=15151, draws=4835
n=16, time=0.000147, alice wins=25780, bob wins=30398, draws=9358
n=17, time=0.000143, alice wins=51962, bob wins=60917, draws=18193
n=18, time=0.000167, alice wins=104759, bob wins=122116, draws=35269
n=19, time=0.000168, alice wins=210934, bob wins=244786, draws=68568
n=20, time=0.000195, alice wins=424404, bob wins=490435, draws=133737
n=21, time=0.000254, alice wins=853806, bob wins=982544, draws=260802
n=22, time=0.000389, alice wins=1716759, bob wins=1968413, draws=509132
n=23, time=0.000658, alice wins=3450158, bob wins=3942649, draws=995801
n=24, time=0.001163, alice wins=6932169, bob wins=7896116, draws=1948931
n=25, time=0.002187, alice wins=13924260, bob wins=15813268, draws=3816904
n=26, time=0.004154, alice wins=27959805, bob wins=31665423, draws=7483636
n=27, time=0.010882, alice wins=56130762, bob wins=63403245, draws=14683721
n=28, time=0.015988, alice wins=112662414, bob wins=126945244, draws=28827798
n=29, time=0.031405, alice wins=226080318, bob wins=254152625, draws=56637969
n=30, time=0.061216, alice wins=453595341, bob wins=508798604, draws=111347879
n=31, time=0.121005, alice wins=909925794, bob wins=1018538560, draws=219019294
n=32, time=0.263231, alice wins=1825052601, bob wins=2038870881, draws=431043814
n=33, time=0.494385, alice wins=3660020992, bob wins=4081149015, draws=848764585
n=34, time=0.978709, alice wins=7339006091, bob wins=8168806568, draws=1672056525
n=35, time=1.944308, alice wins=14714278862, bob wins=16350068706, draws=3295390800
n=36, time=3.738583, alice wins=29497991764, bob wins=32723948523, draws=6497536449
n=37, time=9.755808, alice wins=59129191502, bob wins=65493519976, draws=12816241994
n=38, time=15.553550, alice wins=118514143839, bob wins=131074624997, draws=25289138108
n=39, time=30.759220, alice wins=237519754398, bob wins=262317425785, draws=49918633705
n=40, time=60.708877, alice wins=475985181699, bob wins=524958142500, draws=98568303577
n=41, time=120.777431, alice wins=953791746232, bob wins=1050538666974, draws=194692842346
n=42, time=236.792906, alice wins=1911094220329, bob wins=2102276334809, draws=384675955966
```
