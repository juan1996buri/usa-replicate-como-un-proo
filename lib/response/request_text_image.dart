class RequestTextImage {
  final String prompt;

  final String negativePrompt;
  final String scheduler;

  const RequestTextImage({
    required this.prompt,
    required this.negativePrompt,
    required this.scheduler,
  });

  RequestTextImage copyWith({
    String? prompt,
    String? negativePrompt,
    String? scheduler,
  }) {
    return RequestTextImage(
      prompt: prompt ?? this.prompt,
      negativePrompt: negativePrompt ?? this.negativePrompt,
      scheduler: scheduler ?? this.scheduler,
    );
  }
}
