import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zero_waste/models/business_owner.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/providers/user_provider.dart';
import 'package:zero_waste/repositories/business_owner_repository.dart';
import 'package:zero_waste/repositories/household_user_repository.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/date_picker.dart';
import 'package:zero_waste/widgets/select_dropdown.dart';
import 'package:zero_waste/widgets/text_field_input.dart';
import '../../widgets/submit_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {

  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _nicController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _noOfHouseholds;
  DateTime dob = DateTime.now();

  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  String? _noOfEmployees;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User registration'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/home');
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[300],
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.house),
            ),
            Tab(
              icon: Icon(Icons.business),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: householdRegister(context),
          ),
          Center(
            child: businessRegister(context),
          ),
        ],
      ),
    );
  }

  Widget householdRegister(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldInput(
                      title: 'First Name',
                      icon: Icons.person,
                      controller: _fnameController,
                      inputType: TextInputType.text,
                      validator: Validators.nullCheck,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Last Name",
                        icon: Icons.person,
                        controller: _lnameController,
                        inputType: TextInputType.text,
                        validator: Validators.nullCheck),
                    const SizedBox(height: 16),
                    DatePicker(
                      title: "Date Of Birth",
                      onChangedDay: (value) =>
                          dob = DateTime(dob.year, dob.month, value!),
                      onChangedMonth: (value) =>
                          dob = DateTime(dob.year, value!, dob.day),
                      onChangedYear: (value) =>
                          dob = DateTime(value!, dob.month, dob.day),
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "NIC",
                        icon: Icons.person,
                        controller: _nicController,
                        inputType: TextInputType.text,
                        validator: Validators.validateNIC),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Contact Number",
                        icon: Icons.person,
                        controller: _mobileNoController,
                        inputType: TextInputType.number,
                        validator: Validators.validateMobile),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Address",
                        icon: Icons.person,
                        controller: _addressController,
                        inputType: TextInputType.text,
                        validator: Validators.nullCheck),
                    const SizedBox(height: 16),
                    SelectDropdown(
                        title: "No of Households",
                        items: const [
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10'
                        ],
                        selectedValue: _noOfHouseholds,
                        onChanged: (String? newValue) {
                          setState(() {
                            _noOfHouseholds = newValue;
                          });
                        },
                        hint: "Select Item"),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      title: "Email",
                      icon: Icons.person,
                      controller: _emailController,
                      validator: Validators.validateEmail,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      title: "Password",
                      icon: Icons.person,
                      controller: _passwordController,
                      inputType: TextInputType.visiblePassword,
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 24),
                    SubmitButton(
                        icon: Icons.send,
                        text: "Register",
                        whenPressed: _submitForm),
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Already have an account?",
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(
                          text: "Login",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.orangeAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go("/user/login");
                            })
                    ]))
                  ],
                ),
              ),
            ))
          ],
        )),
      ),
    );
  }

  Widget businessRegister(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _businessFormKey,
                child: Column(
                  children: [
                    TextFieldInput(
                      title: 'Company Name',
                      icon: Icons.business,
                      controller: _companyNameController,
                      inputType: TextInputType.text,
                      validator: Validators.nullCheck,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Contact Person Name",
                        icon: Icons.person,
                        controller: _contactPersonController,
                        inputType: TextInputType.text,
                        validator: Validators.nullCheck),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Contact Number",
                        icon: Icons.person,
                        controller: _mobileNoController,
                        inputType: TextInputType.number,
                        validator: Validators.validateMobile),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Address",
                        icon: Icons.person,
                        controller: _addressController,
                        inputType: TextInputType.text,
                        validator: Validators.nullCheck),
                    const SizedBox(height: 16),
                    SelectDropdown(
                        title: "No of Employees",
                        items: const [
                          '1 - 50',
                          '51 - 100',
                          '100 - 200',
                          '200+',
                        ],
                        selectedValue: _noOfEmployees,
                        onChanged: (String? newValue) {
                          setState(() {
                            _noOfEmployees = newValue;
                          });
                        },
                        hint: "Select Item"),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      title: "Email",
                      icon: Icons.person,
                      controller: _emailController,
                      validator: Validators.validateEmail,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      title: "Password",
                      icon: Icons.person,
                      controller: _passwordController,
                      inputType: TextInputType.visiblePassword,
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 24),
                    SubmitButton(
                        icon: Icons.send,
                        text: "Register",
                        whenPressed: _submitBusinessForm),
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Already have an account?",
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(
                          text: "Login",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.orangeAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go("/user/login");
                            })
                    ]))
                  ],
                ),
              ),
            ))
          ],
        )),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = User(
        email: _emailController.text,
        password: _passwordController.text,
        userType: 'HouseholdUser',
      );
      final householdUser = HouseholdUser(
        fName: _fnameController.text,
        lName: _lnameController.text,
        dob: dob,
        nic: _nicController.text,
        mobile: _mobileNoController.text,
        address: _addressController.text,
        user: user,
      );
      Provider.of<UserProvider>(context, listen: false).addUser(user).then((_) {
        HouseholdUserRepository().addUser(householdUser).then((_) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('User Registered Successfully'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          context.go("/home");
        }).catchError((error, stack) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Failed to Register Household User'),
                content: Text(error.toString()),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
      }).catchError((error) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Failed to Register User'),
              content: Text(error.toString()),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  void _submitBusinessForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = User(
        email: _emailController.text,
        password: _passwordController.text,
        userType: 'BusinessOwner',
      );
      final businessOwner = BusinessOwner(
        companyName: _companyNameController.text,
        contactPersonName: _contactPersonController.text,
        mobile: _mobileNoController.text,
        address: _addressController.text,
        user: user,
      );
      Provider.of<UserProvider>(context, listen: false).addUser(user).then((_) {
        BusinessOwnerRepository().addBusinessUser(businessOwner).then((_) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('User Registered Successfully'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          context.go("/home");
        }).catchError((error, stack) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Failed to Register Business User'),
                content: Text(error.toString()),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
      }).catchError((error) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Failed to Register User'),
              content: Text(error.toString()),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }
}
