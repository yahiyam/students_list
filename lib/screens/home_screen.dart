import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../boxes/boxes.dart';
import '../models/notes_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();
  FocusNode classFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  bool nameHasFocus = false;
  bool ageHasFocus = false;
  bool classHasFocus = false;
  bool phoneHasFocus = false;
  bool validated = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    nameFocusNode.dispose();
    ageController.dispose();
    ageFocusNode.dispose();
    classController.dispose();
    classFocusNode.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Students'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('Sorry:(   work in progress'),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showForm(context, null);
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(),
                          const SizedBox(width: 20),
                          Text(data[index].name.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              editMyDialog(
                                data[index],
                                data[index].name.toString(),
                                data[index].age.toString(),
                                data[index].clas.toString(),
                                data[index].phone.toString(),
                              );
                            },
                            child: const Icon(Icons.edit),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              delete(data[index]);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showForm(BuildContext ctx, int? itemKey) async {
    return showModalBottomSheet(
      context: ctx,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                focusNode: nameFocusNode,
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter name',
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    nameFocusNode.requestFocus();
                    nameHasFocus = true;
                    return 'Please enter your name';
                  } else {
                    nameHasFocus = false;
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                focusNode: ageFocusNode,
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter age',
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    ageFocusNode.requestFocus();
                    ageHasFocus = true;
                    return 'Please enter your age';
                  } else {
                    ageHasFocus = false;
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                focusNode: classFocusNode,
                controller: classController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter class',
                  labelText: 'Class',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    classFocusNode.requestFocus();
                    classHasFocus = true;
                    return 'Please enter your class';
                  } else {
                    classHasFocus = false;
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                focusNode: phoneFocusNode,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Enter mobile number',
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    phoneFocusNode.requestFocus();
                    phoneHasFocus = true;
                    return 'Please enter your phone';
                  } else {
                    phoneHasFocus = false;
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      nameController.clear();
                      ageController.clear();
                      classController.clear();
                      phoneController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final data = NotesModel(
                          name: nameController.text,
                          age: ageController.text,
                          clas: classController.text,
                          phone: phoneController.text,
                        );
                        final box = Boxes.getData();
                        box.add(data);
                        nameController.clear();
                        ageController.clear();
                        classController.clear();
                        phoneController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editMyDialog(NotesModel notesModel, String name, String age,
      String clas, String phone) async {
    // nameController.text = name;
    // ageController.text = age;
    // classController.text = clas;
    // phoneController.text = phone;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    hintText: 'Enter age',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: classController,
                  decoration: const InputDecoration(
                    hintText: 'Enter class',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Enter phone number',
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
          ),
          title: const Text('Edit'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  nameController.clear();
                  ageController.clear();
                  classController.clear();
                  phoneController.clear();
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                notesModel.name = nameController.text.toString();
                notesModel.age = ageController.text.toString();
                notesModel.clas = classController.text.toString();
                notesModel.phone = phoneController.text.toString();
                await notesModel.save();

                nameController.clear();
                ageController.clear();
                classController.clear();
                phoneController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }
}
