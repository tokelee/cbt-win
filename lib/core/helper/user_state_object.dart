class UserState {
  String firstName;
  String lastName;
  String username;

  UserState({
    required this.username,
    required this.firstName,
    required this.lastName
  });
}

UserState userState = UserState(firstName: "", lastName: "", username: "");