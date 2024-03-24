enum RouteName {
  initial('/'),
  maintenance('/maintenance'),
  update('/update'),
  unsupported('/unsupported'),
  onboarding('/onboarding'),
  login('/login'),
  home('/home'),
  activity('/activity'),
  account('/account'),
  message('/message'),
  chat('/chats'),
  notifications('/notifications'),
  error('/error'),
  profile('/profile'),
  createPost('/create_post'),
  postDetails(':postId');

  const RouteName(this.path);
  final String path;
}
