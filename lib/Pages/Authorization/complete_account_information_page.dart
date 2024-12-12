import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Components/BottomNavigation/bottom_navigation.dart';
import 'package:social_tripper_mobile/Components/Shared/authorization_logo_header.dart';
import 'package:social_tripper_mobile/Components/Shared/language_master.dart';
import 'package:social_tripper_mobile/Models/Account/account.dart';
import 'package:social_tripper_mobile/Models/Activity/activity_skill.dart';
import 'package:social_tripper_mobile/Models/Language/language_skill.dart';
import 'package:social_tripper_mobile/Models/User/user.dart';
import 'package:social_tripper_mobile/Models/User/user_dto.dart';
import 'package:social_tripper_mobile/Pages/TripDetail/Subpages/trip_detail_details.dart';
import 'package:social_tripper_mobile/Services/account_service.dart';
import 'package:social_tripper_mobile/Services/user_service.dart';
import 'package:social_tripper_mobile/Utilities/Converters/language_converter.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/activity_retriever.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/flag_retriever.dart';

import '../../Utilities/DataGenerators/Trip/skills_data_source.dart';

class CompleteAccountInformationPage extends StatefulWidget {
  final String email;

  const CompleteAccountInformationPage({super.key, required this.email});

  @override
  State<CompleteAccountInformationPage> createState() =>
      _CompleteAccountInformationPageState();
}

class _CompleteAccountInformationPageState
    extends State<CompleteAccountInformationPage> {
  int page = 1;
  late List<DropdownMenuItem<String>> phoneCodesItems;
  late List<DropdownMenuItem<String>> countriesItems;
  String? _name;
  String? _surname;
  String? _selectedGender = "M";
  String? _phoneNumber;
  DateTime? _birthDate;
  String? _country;
  String? _nickname;
  String? _profilePicture;
  File? _profilePictureFile;
  double? _weight;
  double? _height;
  double? _physicality;
  String? _description;
  Set<Activity> activities = {};
  Set<Language> languages = {};
  String? _selectedActivity;
  late final String _email;
  late TextEditingController _nameController;
  late TextEditingController _nicknameController;
  late TextEditingController _surnameController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _profilePictureController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _descriptionController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late final List<String> _availableActivities;
  late final List<String> _availableLanguages;

  // List<DropdownMenuItem<String>> getAllCountriesItems() {
  //
  // }

  @override
  void initState() {
    _nameController = TextEditingController(text: _name);
    _surnameController = TextEditingController(text: _surname);
    _dateOfBirthController = TextEditingController(
      text: _birthDate == null
          ? "Select date"
          : '${_birthDate!.toLocal()}'.split(' ')[0],
    );
    _phoneNumberController = TextEditingController(text: _phoneNumber);
    _nicknameController = TextEditingController(text: _nickname);
    _profilePictureController = TextEditingController(text: _profilePicture);
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _descriptionController = TextEditingController();
    phoneCodesItems = getAllPhoneCodesItems();
    countriesItems = getAllCountriesItems();
    _physicality = 5.0;
    _availableActivities = getAllActivities();
    _availableLanguages = getAllLanguages();
    _email = widget.email;

    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = currentDate;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? currentDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _birthDate) {
      setState(() {
        _birthDate = pickedDate;
        _dateOfBirthController.text = '${_birthDate!.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      // Wybór obrazu z galerii
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _profilePicture = image.path; // Ścieżka do obrazu
          _profilePictureController.text =
              image.name; // Wyświetlenie nazwy w polu tekstowym
          _profilePictureFile = File(image.path); // Konwersja do pliku
        });
      }
    } catch (e) {
      // Obsługa błędu
      print("Error picking image: $e");
    }
  }

  List<String> getAllActivities() {
    return SkillsDataSource.activities;
  }

  List<String> getAllLanguages() {
    return SkillsDataSource.languages;
  }

  List<DropdownMenuItem<String>> getAllCountriesItems() {
    List<DropdownMenuItem<String>> items = [];
    List<String> countries = LanguageConverter.getAllCountries();
    for (var country in countries) {
      items.add(DropdownMenuItem<String>(
        value: country,
        child: Row(
          children: [
            Text(
              country,
              style: TextStyle(fontSize: 14), // Opcjonalne dostosowanie stylu
              overflow: TextOverflow.ellipsis, // Dla długiego tekstu
            ),
            SizedBox(
              width: 9,
            ),
            Container(
              width: 15,
              height: 15,
              child: LanguageMaster(
                FlagRetriever().retrieveByCountryName(country, 15),
              ),
            ),
          ],
        ),
      ));
    }

    return items;
  }

  List<DropdownMenuItem<String>> getAllPhoneCodesItems() {
    List<DropdownMenuItem<String>> items = [];
    List<String> codes = LanguageConverter.getAllPhoneCodes();

    for (var code in codes) {
      items.add(DropdownMenuItem<String>(
        value: code,
        child: Row(
          children: [
            // Text(
            //   code,
            //   style: TextStyle(fontSize: 14), // Opcjonalne dostosowanie stylu
            //   overflow: TextOverflow.ellipsis, // Dla długiego tekstu
            // ),
            // SizedBox(width: 9,),
            Container(
              width: 15,
              height: 15,
              child: LanguageMaster(
                FlagRetriever().retrieveByPhoneCode(code, 15),
              ),
            ),
          ],
        ),
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    Widget? child;

    switch (page) {
      case 1:
        child = Page1(context);
      case 2:
        child = Page2(context);
      default:
        child = Page3(context);
    }

    return SafeArea(
      child: child,
    );
  }

  Widget Page3(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 32),
          child: AuthorizationLogoHeader(),
        ),
        StepsRow(),
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Form(
            child: Column(
              children: [
                // DropdownButtonFormField
                DropdownButtonFormField<String>(
                  value: null,
                  // `null` jako wartość wyjściowa, bo placeholder jest stały
                  items: _availableActivities.map((activity) {
                    return DropdownMenuItem<String>(
                      value: activity,
                      child: Text(activity),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      // Sprawdzamy, czy aktywność już jest w zbiorze
                      bool activityExists = activities
                          .any((activity) => activity.name == newValue);

                      if (!activityExists) {
                        // Jeśli aktywność nie istnieje, dodajemy ją do zbioru
                        setState(() {
                          _selectedActivity = newValue;
                          final newOne = Activity(5.0, newValue);
                          activities.add(newOne);
                        });
                      } else {
                        // Jeśli aktywność już istnieje, nic nie robimy
                        print("This activity is already added.");
                      }
                    }
                  },
                  decoration: MyInputDecoration(
                    "choose activity",
                    SvgPicture.asset("assets/icons/main_logo.svg", width: 26),
                    null,
                  ),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Text("Choose an activity"),
                  ),
                  // Stały tekst jako placeholder
                  selectedItemBuilder: (BuildContext context) {
                    return _availableActivities.map((_) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 9),
                        child: Text("Choose an activity"),
                      );
                    }).toList();
                  },
                ),
                SizedBox(height: 32),

                // ListView.builder dla aktywności
                if (activities.isNotEmpty) ActivitiesBuilder(),

                DropdownButtonFormField<String>(
                  value: null,
                  // `null` jako wartość wyjściowa, bo placeholder jest stały
                  items: _availableLanguages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      // Sprawdzamy, czy język już jest w zbiorze
                      bool languageExists = languages
                          .any((language) => language.name == newValue);

                      if (!languageExists) {
                        // Jeśli język nie istnieje, dodajemy go do zbioru
                        setState(() {
                          final newLanguage = Language(5.0,
                              newValue); // Tworzymy nowy obiekt LanguageSkill
                          languages.add(newLanguage);
                        });

                        // Debug: Wyświetlenie aktualnej zawartości zbioru
                        print(
                            "Languages set: ${languages.map((e) => e.name)
                                .toList()}");
                      } else {
                        // Jeśli język już istnieje, nic nie robimy
                        print("This language is already added.");
                      }
                    }
                  },
                  decoration: MyInputDecoration(
                    "choose language",
                    SvgPicture.asset("assets/icons/main_logo.svg", width: 26),
                    null,
                  ),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Text("Choose a language"),
                  ),
                  // Stały tekst jako placeholder
                  selectedItemBuilder: (BuildContext context) {
                    return _availableLanguages.map((_) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 9),
                        child: Text("Choose a language"),
                      );
                    }).toList();
                  },
                ),

                SizedBox(height: 32),

// ListView.builder dla języków
                if (languages.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: languages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final language = languages
                          .elementAt(index); // Używamy `elementAt` dla Set

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 9.0),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              child:
                              FlagRetriever().retrieve(language.name, 30),
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("${language.name}"),
                                      Expanded(child: Text("")),
                                      Text(
                                          "Score: ${language.level
                                              .toStringAsFixed(1)}"),
                                      // Zaokrąglamy wynik do 1 miejsca po przecinku
                                    ],
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 10.0,
                                      activeTrackColor: Color(0xFFBDF271),
                                      inactiveTrackColor: Colors.grey[300],
                                      thumbColor: Colors.black,
                                      overlayColor:
                                      Colors.blue.withOpacity(0.2),
                                      valueIndicatorColor: Colors.blue,
                                      valueIndicatorTextStyle:
                                      TextStyle(color: Colors.white),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 0),
                                    ),
                                    child: Slider(
                                      value: language.level ?? 0,
                                      // Domyślna wartość to 0
                                      min: 0,
                                      max: 10,
                                      divisions: 100,
                                      onChanged: (value) {
                                        setState(() {
                                          language.level = double.parse(
                                              value.toStringAsFixed(1));
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: NavigationButton("Back", false, () {
                  setState(() {
                    page = 2;
                  });
                }),
              ),
              Expanded(child: Text("")),
              Padding(
                padding: const EdgeInsets.all(18),
                child: NavigationButton("Register", true, () async {
                  double? _heightTemp = _height;
                  _weight = _weight != null
                      ? double.parse((_weight!).toStringAsFixed(1))
                      : null; // Formatowanie wagi
                  _height = _heightTemp != null
                      ? double.parse((_heightTemp! / 100).toStringAsFixed(2))
                      : null; // Formatowanie wzrostu
                  UserDTO userDTO = UserDTO(
                    "",
                    _name!,
                    _surname!,
                    _selectedGender!,
                    _birthDate!,
                    _weight!,
                    _height!,
                    0,
                    _physicality!,
                    Account(
                      "",
                      _nickname!,
                      _email,
                      true,
                      _phoneNumber!,
                      "",
                      false,
                      false,
                      DateTime.now(),
                      "",
                      _description!,
                      0,
                      0,
                      0,
                      _profilePicture!,
                      null,
                    ),
                    Country(_country!),
                    languages,
                    activities,
                  );
                  try {
                    await UserService().createUser(userDTO, _profilePicture);
                    await AccountService().getCurrentAccount();
                    context.go("/home");
                  } catch (e) {
                    print("error creating user: $e");
                  }
                  // Generowanie UUID
                  // final String uuid = "131232321";
                  //
                  // // Przygotowanie minimalnych danych
                  // final String formattedDate = DateTime.now().toIso8601String();
                  // UserDTO userDTO = UserDTO(
                  //   null, // uuid
                  //   'TestName', // name
                  //   'TestSurname', // surname
                  //   'M', // gender
                  //   DateTime.now(), // dateOfBirth
                  //   70.0, // weight
                  //   1.7, // height
                  //   null, // bmi
                  //   5.0, // physicality
                  //   Account(
                  //     null, // account uuid
                  //     'TestNickname', // nickname
                  //     'test@example.com', // email
                  //     true, // isPublic
                  //     '123456789', // phone
                  //     '', // role
                  //     false, // isExpired
                  //     false, // isLocked
                  //     DateTime.now(), // createdAt
                  //     '', // homePageUrl
                  //     'Test Description', // description
                  //     0, // followersNumber
                  //     0, // followingNumber
                  //     0, // numberOfTrips
                  //     '', // profilePictureUrl
                  //     null, // user
                  //   ),
                  //   Country('Poland'), // country
                  //   {}, // languages
                  //   {}, // activities
                  // );
                  //
                  // print("Sending data to server: ${jsonEncode(userDTO.toJson())}");
                  // await UserService().createUser(userDTO, _profilePicture);  // No profile picture
                }),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  ListView ActivitiesBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // Zapewnia, że lista nie będzie przewijana osobno
      itemCount: activities.length,
      itemBuilder: (BuildContext context, int index) {
        final List<Activity> activityList = activities.toList();
        final Activity activity = activityList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 9.0),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                child: ActivityRetriever().retrieve(activity.name, 30),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("${activity.name}"),
                        Expanded(child: Text("")),
                        Text(
                            "Score: ${activity.experience.toStringAsFixed(1)}"),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 10.0,
                        activeTrackColor: Color(0xFFBDF271),
                        // Kolor aktywnej części ścieżki
                        inactiveTrackColor: Colors.grey[300],
                        // Kolor nieaktywnej części ścieżki
                        thumbColor: Colors.black,
                        overlayColor: Colors.blue.withOpacity(0.2),
                        // Kolor overlay (nałożenie) na thumb podczas interakcji
                        valueIndicatorColor: Colors.blue,
                        valueIndicatorTextStyle: TextStyle(color: Colors.white),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                      ),
                      child: Slider(
                        value: activity.experience ?? 0,
                        min: 0,
                        max: 10,
                        divisions: 100,
                        onChanged: (value) {
                          print(activities);
                          setState(() {
                            activity.experience =
                                double.parse(value.toStringAsFixed(1));
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget Page2(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 32),
            child: AuthorizationLogoHeader(),
          ),
          StepsRow(),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Form(
              // Przeniesienie Form tutaj, aby obejmowało cały formularz
              key: _formKey2,
              child: Column(
                // Zmiana z Row na Column, aby każdy element był w nowym wierszu
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormTextInput(
                      "Nickname", "Nickname", null, _nicknameController, (val) {
                    setState(() {
                      _nickname = val;
                    });
                  }, validator: (val) {
                    if (_nickname == null || _nickname!.isEmpty) {
                      return "Please fill nickname";
                    }
                    return null;
                  }),
                  SizedBox(height: 18),
                  FormTextInput(
                    "Profile picture",
                    "photo.example",
                    Icon(Icons.photo),
                    _profilePictureController,
                        (val) {
                      setState(() {
                        _profilePicture = val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val!.isEmpty) {
                        return "Please upload a profile picture";
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: _pickImage,
                  ),
                  SizedBox(height: 18),
                  PhotoRow(),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: FormTextInput(
                            "Weight (kg)", "xx.x", null, _weightController,
                                (value) {
                              setState(() {
                                _weight = double.tryParse(value);
                              });
                            }, validator: (value) {
                          if (_weight == null || _weight
                              .toString()
                              .isEmpty) {
                            return "Please fill weight";
                          }
                          return null;
                        }, formatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d{0,2}(\.\d{0,1})?$')),
                        ]),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: FormTextInput(
                          "Height (cm)",
                          "xxx",
                          null,
                          _heightController,
                              (value) {
                            setState(() {
                              _height = double.tryParse(value);
                            });
                          },
                          validator: (value) {
                            if (_height == null || _height
                                .toString()
                                .isEmpty) {
                              return "Please fill height";
                            }
                            return null;
                          },
                          formatters: [
                            // Formatter do limitowania do maksymalnie 3 cyfr
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d{0,3}$')),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 18),
                  PhysicalityScore(context),
                  SizedBox(height: 18),
                  FormTextInput("Description", "Description", null,
                      _descriptionController, (val) {
                        setState(() {
                          _description = val;
                        });
                      }, validator: (val) {
                        if (_description == null || _description!.isEmpty) {
                          return "Please fill description";
                        }
                        return null;
                      }),
                  SizedBox(height: 18),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: NavigationButton("Back", false, () {
                    setState(() {
                      page = 1;
                    });
                  }),
                ),
                Expanded(child: Text("")),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: NavigationButton("Next", true, () {
                    if (_formKey2.currentState!.validate()) {
                      // Jeśli formularz jest poprawny, wykonaj akcję
                      setState(() {
                        page = 3;
                      });
                    } else {
                      // Jeśli formularz zawiera błędy, pokaż komunikat
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                            Text("Please fill in all required fields")),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column PhysicalityScore(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTitle("Physicality score"),
        Container(
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                child: Image.asset("assets/icons/bicep_filled_black.png"),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("")),
                        Text("Score: ${round(_physicality ?? 0)}"),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 10.0,
                        activeTrackColor: Color(0xFFBDF271),
                        // Kolor aktywnej części ścieżki
                        inactiveTrackColor: Colors.grey[300],
                        // Kolor nieaktywnej części ścieżki
                        thumbColor: Colors.black,
                        overlayColor: Colors.blue.withOpacity(0.2),
                        // Kolor overlay (nałożenie) na thumb podczas interakcji
                        valueIndicatorColor: Colors.blue,
                        valueIndicatorTextStyle: TextStyle(color: Colors.white),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                      ),
                      child: Slider(
                        value: _physicality ?? 0,
                        min: 0,
                        max: 10,
                        divisions: 100,
                        onChanged: (value) {
                          setState(() {
                            _physicality = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  PhotoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _profilePicture != null
            ? Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
            image: DecorationImage(
              image: FileImage(_profilePictureFile!), // Wybrane zdjęcie
              fit: BoxFit.cover,
            ),
          ),
        )
            : Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Icon(
            Icons.photo_camera,
            size: 60, // Wymiar ikony, dostosuj do potrzeb
            color: Colors.black.withOpacity(0.65), // Kolor ikony
          ),
        ),
      ],
    );
  }

  Widget Page1(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 32),
            child: AuthorizationLogoHeader(),
          ),
          StepsRow(),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Form(
              // Przeniesienie Form tutaj, aby obejmowało cały formularz
              key: _formKey,
              child: Column(
                // Zmiana z Row na Column, aby każdy element był w nowym wierszu
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child:
                        FormTextInput("Name", "Name", null, _nameController,
                            validator: (val) {
                              if (_name == null || _name!.isEmpty) {
                                return "Please fill name";
                              }
                              return null;
                            }, (value) {
                              setState(() {
                                _name = value;
                              });
                            }),
                      ),
                      SizedBox(width: 18),
                      Expanded(
                        child: FormTextInput(
                            "Surname", "Surname", null, _surnameController,
                            validator: (val) {
                              if (_surname == null || _surname!.isEmpty) {
                                return "Please fill surname";
                              }
                              return null;
                            }, (value) {
                          setState(() {
                            _surname = value;
                          });
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  FormCheckInputRow("Male", "M", "Female", "F"),
                  SizedBox(height: 18),
                  FormTextInput(
                    "Date of birth",
                    "Date of birth",
                    null,
                    _dateOfBirthController,
                        (val) {},
                    suffixIcon: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    validator: (value) {
                      if (_birthDate == null) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  FormTextInput(
                    "Phone number",
                    "Your phone number",
                    null,
                    _phoneNumberController,
                        (val) {
                      setState(() {
                        _phoneNumber = val;
                      });
                    },
                    inputType: TextInputType.phone,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please fill phone number";
                      }

                      // Sprawdzanie, czy numer telefonu jest poprawny za pomocą wyrażenia regularnego
                      RegExp phoneRegExp = RegExp(
                          r'^[+0-9]{1,4}[0-9]{6,15}$'); // przykład regex dla numeru telefonu
                      if (!phoneRegExp.hasMatch(val)) {
                        return "Please provide a valid phone number";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  InputTitle("Country"),
                  SizedBox(height: 9),
                  ShadowedContainer(CountriesDropdown(countriesItems, (value) {
                    print(value);
                    setState(() {
                      _country = value;
                    });
                  })),
                  // Ten widget się będzie przesuwał w dół przy pojawieniu się klawiatury
                ],
              ),
            ),
          ),
          // Przyklejamy przycisk na dole ekranu
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: NavigationButton("Next", true, () {
                if (_formKey.currentState!.validate()) {
                  // Jeśli formularz jest poprawny, wykonaj akcję
                  setState(() {
                    page = 2;
                  });
                } else {
                  // Jeśli formularz zawiera błędy, pokaż komunikat
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Please fill in all required fields")),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget NavigationButton(String text, bool isForward,
      void Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: Color(isForward ? 0xFF000000 : 0xFFF0F2F5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 24),
          child: Text(
            text,
            style: TextStyle(
              color: Color(isForward ? 0xFFBDF271 : 0xFF000000),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Container ShadowedContainer(Widget child) {
    return Container(
      child: child,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)
          ]),
    );
  }

  Widget CountriesDropdown(List<DropdownMenuItem<String>> countriesItems,
      void Function(String?) onChanged) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _country,
          items: countriesItems,
          onChanged: onChanged,
          underline: null,
          isExpanded: true,
        ),
      ),
    );
  }

  Widget PhoneCodesDropdown(List<DropdownMenuItem<String>> phoneCodesItems,
      void Function(String?) onChanged) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: phoneCodesItems[0].value,
          items: phoneCodesItems,
          onChanged: onChanged,
          underline: null,
          isExpanded: true,
        ),
      ),
    );
  }

  Widget FormCheckInputRow(String name1, String value1, String name2,
      String value2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTitle("Gender"),
        SizedBox(
          height: 9,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGender = "M";
                  });
                },
                child: FormRadioInput("Male", "M"),
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGender = "K";
                  });
                },
                child: FormRadioInput("Female", "K"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget FormRadioInput(String name, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(0, 0)),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
            visualDensity: VisualDensity(horizontal: -2.8, vertical: -2.4),
          ),
          SizedBox(
            width: 0,
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: "Source Sans 3",
            ),
          )
        ],
      ),
    );
  }

  Widget FormTextInput(String title, String hint, Widget? leading,
      TextEditingController controller, void Function(String) onChanged,
      {TextInputType inputType = TextInputType.text,
        Widget? suffixIcon,
        void Function()? onTap,
        bool readOnly = false,
        required String? Function(String?) validator,
        List<TextInputFormatter> formatters = const []}) {
    print("walidator: $validator");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTitle(title),
        SizedBox(
          height: 9,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: Offset(0, 0)),
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: inputType,
            inputFormatters: formatters,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Source Sans 3",
              fontWeight: FontWeight.w500,
            ),
            decoration: MyInputDecoration(hint, leading, suffixIcon),
            onChanged: onChanged,
            onTap: onTap,
            validator: validator,
          ),
        )
      ],
    );
  }

  Text InputTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: "Source Sans 3",
      ),
    );
  }

  InputDecoration MyInputDecoration(String hint, Widget? leading,
      Widget? suffixIcon) {
    return InputDecoration(
        fillColor: Colors.white,
        hintText: hint,
        border: MyInputBorder(),
        focusedBorder: MyInputBorder(),
        enabledBorder: MyInputBorder(),
        errorBorder: MyInputBorder(),
        disabledBorder: MyInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        isDense: true,
        suffixIcon: suffixIcon,
        prefixIcon: leading);
  }

  OutlineInputBorder MyInputBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.transparent));
  }

  Padding StepsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MultiStepFormStep(1, "User", page == 1),
          MultiStepFormStep(2, "Account", page == 2),
          MultiStepFormStep(3, "Skills", page == 3),
        ],
      ),
    );
  }

  Row MultiStepFormStep(int number, String name, bool isActive) {
    return Row(
      children: [
        MultiStepFormOptionNumber(number, isActive),
        SizedBox(
          width: 7,
        ),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isActive ? Colors.black : Colors.black.withOpacity(0.5),
          ),
        )
      ],
    );
  }

  Container MultiStepFormOptionNumber(int number, bool isActive) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.black.withOpacity(0.5), width: isActive ? 0 : 2),
          boxShadow: isActive
              ? [
            BoxShadow(
                color: Color(0xFFBDF271), blurRadius: 2, spreadRadius: 2)
          ]
              : []),
      child: Container(
        height: isActive ? 22 : 20,
        width: isActive ? 22 : 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(
          "$number",
          style: TextStyle(
              color:
              isActive ? Color(0xffBDF271) : Colors.black.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
