library(httptest2)
.mockPaths("../")
if (!nzchar(Sys.getenv("OP3_API_TOKEN"))) {
  Sys.setenv(OP3_API_TOKEN = "foobar")
}
