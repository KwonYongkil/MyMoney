    package function;

import fitnesse.responders.run.SuiteResponder;
import fitnesse.wiki.*;

public class FitnessExample {
    public String testableHtml(PageData pageData, boolean includeSuiteSetup) throws Exception {
        return new MakeWikiPage(pageData, includeSuiteSetup).invoke();
    }

    private class MakeWikiPage {
        private PageData pageData;
        private boolean includeSuiteSetup;
        private WikiPage wikiPage;
        private final StringBuffer buffer;

        public MakeWikiPage(PageData pageData, boolean includeSuiteSetup) {
            this.pageData = pageData;
            this.includeSuiteSetup = includeSuiteSetup;
            wikiPage = pageData.getWikiPage();
            buffer = new StringBuffer();
        }

        public String invoke() throws Exception {
            String page = "";

            if (isTestPage())
                page = getWikiPage();
            pageData.setContent(page);
            return pageData.getHtml();
        }

        private boolean isTestPage() throws Exception {
            return pageData.hasAttribute("Test");
        }

        private String getWikiPage() throws Exception {
            String page = "";
            page = getSetupPart();
            page += pageData.getContent();
            page += getTearDownPart();
            return page;
        }

        private String getTearDownPart() throws Exception {
            String page = "";
            page = getInheritedPage("teardown", "TearDown");
            if (includeSuiteSetup)
                page += getInheritedPage("teardown", SuiteResponder.SUITE_TEARDOWN_NAME);
            return page;
        }

        private String getSetupPart() throws Exception {
            String page = "";
            if (includeSuiteSetup)
                page = getInheritedPage("setup", SuiteResponder.SUITE_SETUP_NAME);
            page += getInheritedPage("setup", "SetUp");
            return page;
        }

        private String getInheritedPage(String mode, String pageName) throws Exception {
            WikiPage suiteSetup = PageCrawlerImpl.getInheritedPage(pageName, wikiPage);
            if (suiteSetup != null)
                return getRenderedPage(mode, suiteSetup);
            return "";
        }

        private String getRenderedPage(String mode, WikiPage suiteSetup) throws Exception {
            WikiPagePath pagePath = wikiPage.getPageCrawler().getFullPath(suiteSetup);
            String pagePathName = PathParser.render(pagePath);
            return String.format("!include -%s .%s\n", mode, pagePathName);
        }
    }
}