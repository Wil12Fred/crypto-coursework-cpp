// Minimal assertion helper shared by the unit tests.
#include <cstdio>
#include <cstdlib>
#include <string>

static int g_failures = 0;
static int g_checks = 0;

#define CHECK_EQ(got, want, what)                                          \
  do {                                                                     \
    ++g_checks;                                                            \
    if (!((got) == (want))) {                                              \
      ++g_failures;                                                        \
      if (g_failures <= 10)                                                \
        std::printf("FAIL %s:%d %s\n  got:  [%s]\n  want: [%s]\n",         \
                    __FILE__, __LINE__, std::string(what).c_str(),         \
                    std::string(got).c_str(), std::string(want).c_str());  \
    }                                                                      \
  } while (0)

#define CHECK(cond, what)                                                  \
  do {                                                                     \
    ++g_checks;                                                            \
    if (!(cond)) {                                                         \
      ++g_failures;                                                        \
      if (g_failures <= 10)                                                \
        std::printf("FAIL %s:%d %s\n", __FILE__, __LINE__,                 \
                    std::string(what).c_str());                            \
    }                                                                      \
  } while (0)

static int report(const char *name) {
  std::printf("%s: %d checks, %d failures\n", name, g_checks, g_failures);
  return g_failures == 0 ? 0 : 1;
}
