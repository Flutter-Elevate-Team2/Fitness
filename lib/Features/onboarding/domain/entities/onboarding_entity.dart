class OnboardingEntity {
  final String title;
  final String description;
  final String image;

  OnboardingEntity({
    required this.title,
    required this.description,
    required this.image,
  });

  static List<OnboardingEntity> getPages() => [
    OnboardingEntity(
      title: "The Price Of Excellence \nIs Discipline",
      description: "Lorem ipsum dolor sit amet consectetur. Eu urna ut gravida quis id pretium purus. Mauris massa ",
      image: "assets/images/onboarding1.png",
    ),
    OnboardingEntity(
      title: "Fitness Has Never Been So \nMuch Fun",
      description: "Lorem ipsum dolor sit amet consectetur. Eu urna ut gravida quis id pretium purus. Mauris massa ",
      image: "assets/images/onboardingg.png",
    ),
    OnboardingEntity(
      title: "NO MORE EXCUSES \nDo It Now",
      description: "Lorem ipsum dolor sit amet consectetur. Eu urna ut gravida quis id pretium purus. Mauris massa ",
      image: "assets/images/onboarding33.png",
    ),
  ];
}