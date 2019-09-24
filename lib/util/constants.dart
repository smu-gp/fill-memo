/// Constant for services
const defaultServiceHost = "127.0.0.1";

String processingServiceUrl(String host) => "http://$host:8000";

/// Constant for token service
const tokenServiceUrl = "https://us-central1-smu-gp.cloudfunctions.net";

/// Memo type
const memoTypes = [typeRichText, typeMarkdown, typeHandWriting];
const typeRichText = "text/richtext";
const typeMarkdown = "text/markdown";
const typeHandWriting = "image/handWriting";

/// Result append type
const appendTypes = [typeNone, typeSpace, typeNewline];
const typeNone = "none";
const typeSpace = "space";
const typeNewline = "newline";
