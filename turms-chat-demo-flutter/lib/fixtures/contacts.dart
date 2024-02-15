import 'package:fixnum/fixnum.dart';

import '../domain/user/models/group_contact.dart';
import '../domain/user/models/user_contact.dart';

class ContactConversation {
  ContactConversation(this.userName, this.messages);

  final String userName;

  final List<String> messages;
}

List<ContactConversation> contactConversations = [
  // Earth
  ContactConversation('Murmurs of Earth - Greetings in 55 languages', [
    '𒁲𒈠𒃶𒈨𒂗',
    'Οἵτινές ποτ᾿ ἔστε χαίρετε! Εἰρηνικῶς πρὸς φίλους ἐληλύθαμεν φίλοι.',
    'Paz e felicidade a todos',
    '各位好嗎？祝各位平安健康快樂。',
    'Adanniš lu šulmu',
    'Здравствуйте! Приветствую Вас!',
    'สวัสดีค่ะ สหายในธรณีโพ้น พวกเราในธรณีนี้ขอส่งมิตรจิตมาถึงท่านทุกคน',
    '.تحياتنا للأصدقاء في النجوم. يا ليت يجمعنا الزمان',
    'Salutări la toată lumea',
    'Bonjour tout le monde',
    'နေကောင်းပါသလား',
    'שלום',
    'Hola y saludos a todos',
    'Selamat malam hadirin sekalian, selamat berpisah dan sampai bertemu lagi dilain waktu',
    'Kay pachamamta niytapas maytapas rimapallasta runasimipi',
    'ਆਓ ਜੀ, ਜੀ ਆਇਆਂ ਨੂੰ',
    'aššuli',
    'নমস্কার, বিশ্বে শান্তি হোক',
    'Salvete quicumque estis; bonam erga vos voluntatem habemus, et pacem per astra ferimus',
    '𐡌𐡋𐡔 or שלם or ܫܠܡ Šəlām',
    'Hartelijke groeten aan iedereen',
    'Herzliche Grüße an alle',
    'السلام عليکم ـ ہم زمين کے رہنے والوں کى طرف سے آپ کو خوش آمديد کہتے ھيں',
    'Chân thành gửi tới các bạn lời chào thân hữu',
    'Sayın Türkçe bilen arkadaşlarımız, sabah şerifleriniz hayrolsun',
    'こんにちは。お元気ですか？',
    'धरती के वासियों की ओर से नमस्कार',
    'Iechyd da i chi yn awr, ac yn oesoedd',
    'Tanti auguri e saluti',
    '	ආයුබෝවන්!',
    'Siya nibingelela maqhawe sinifisela inkonzo ende.',
    'Reani lumelisa marela.',
    '祝㑚大家好。',
    'Բոլոր անոնց որ կը գտնուին տիեզերգի միգամածութիւնէն անդին, ողջոյններ',
    '안녕하세요',
    'Witajcie, istoty z zaświatów.',
    'प्रिथ्वी वासीहरु बाट शान्ति मय भविष्य को शुभकामना',
    '各位都好吧？我们都很想念你们，有空请到这儿来玩。',
    'Mypone kaboutu noose.',
    'Hälsningar från en dataprogrammerare i den lilla universitetsstaden Ithaca på planeten Jorden',
    'Mulibwanji imwe boonse bantu bakumwamba.',
    'પૃથ્વી ઉપર વસનાર એક માનવ તરફથી બ્રહ્માંડના અન્ય અવકાશમાં વસનારાઓને હાર્દિક અભિનંદન. આ સંદેશો મળ્યે, વળતો સંદેશો મોકલાવશો.',
    "Пересилаємо привіт із нашого світу, бажаємо щастя, здоров'я і многая літа",
    'درود بر ساکنین ماورای آسمان‌ها',
    'Желимо вам све најлепше са наше планете',
    'ସୂର୍ଯ୍ୟ ତାରକାର ତୃତୀୟ ଗ୍ରହ ପୃଥିବୀରୁ ବିଶ୍ୱବ୍ରହ୍ମାଣ୍ଡର ଅଧିବାସୀ ମାନଙ୍କୁ ଅଭିନନ୍ଦନ',
    'Musulayo mutya abantu bensi eno mukama abawe emirembe bulijo.',
    'नमस्कार. ह्या पृथ्वीतील लोक तुम्हाला त्यांचे शुभविचार पाठवतात आणि त्यांची इच्छा आहे की तुम्ही ह्या जन्मी धन्य व्हा.',
    '太空朋友，恁好！恁食飽未？有閒著來阮遮坐喔。',
    'Üdvözletet küldünk magyar nyelven minden békét szerető lénynek a Világegyetemen',
    'నమస్తే, తెలుగు మాట్లాడే జనముననించి మా శుభాకాంక్షలు.',
    'Milí přátelé, přejeme vám vše nejlepší',
    'ನಮಸ್ತೆ, ಕನ್ನಡಿಗರ ಪರವಾಗಿ ಶುಭಾಷಯಗಳು.',
    '-',
    'Hello from the children of planet Earth'
  ]),
  // China
  ContactConversation('窦唯', [
    '暮春秋色',
    '多开阔',
    '幻声凋落',
    '曙分',
    '云舞',
    '冬穿梭',
    '往来经过',
    '手挥',
    '捕捉',
    '起风了',
    '骤雨夏天',
    '暮春',
    '秋色',
    '一清池',
    '姽婳妩媚',
    '万丘壑',
    '锦缎绫罗',
    '惑多',
    '已消落',
    '光阴归来',
    '变空白',
    '染尘埃',
    '一并敛埋'
  ]),
  // America
  ContactConversation('Nina Simone', [
    '![Nina Simone - Stars / Feelings (Medley / Live at Montreux, 1976)](https://www.youtube.com/watch?v=Mf_5l1yTKNY)',
    '![butterfly](https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4)'
  ]),
  // Brazil
  ContactConversation('Elis Regina', ['Como Nossos Pais']),
  // Japan
  ContactConversation('Nujabes - Aruarian Dance', []),
];

final fixtureUserContacts = contactConversations.indexed.map((item) {
  final (index, contactConversation) = item;
  return UserContact(
      userId: Int64(index + 1),
      name: contactConversation.userName,
      relationshipGroupId: Int64(1));
}).toList();

final contactToMessages = <Int64, List<String>>{
  for (var value in fixtureUserContacts)
    value.userId: contactConversations
        .firstWhere((item) => item.userName == value.name)
        .messages
};

final fixtureGroupContacts = fixtureUserContacts.indexed.map((item) {
  final (index, _) = item;
  final memberIds = <Int64>{};
  final memberCount = index + 1;
  for (var i = 0; i < memberCount; i++) {
    // TODO: oneself
    memberIds.add(fixtureUserContacts[i].userId);
  }
  return GroupContact(
      groupId: Int64(index + 1), memberIds: memberIds, name: 'fake group name');
}).toList();

final fixtureContacts = [...fixtureUserContacts, ...fixtureGroupContacts];