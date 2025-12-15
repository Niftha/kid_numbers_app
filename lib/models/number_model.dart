class NumberModel {
final int value;
final String word;
final String audioAsset; 
final String imageAsset; 


NumberModel({
required this.value,
required this.word,
required this.audioAsset,
this.imageAsset = '',
});
}


List<NumberModel> numbersList = List.generate(10, (i) {
final v = i + 1;
final words = [
'One','Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten'
];
return NumberModel(
value: v,
word: words[i],
audioAsset: 'assets/audio/$v.mp3',
imageAsset: '',
);
});