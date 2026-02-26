enum UserRole {
  public,
  authenticated,
  manager,
  admin,
}

extension UserRoleX on UserRole {
  bool get canPublish => this == UserRole.manager || this == UserRole.admin;
  bool get canModerate => this == UserRole.admin;
}