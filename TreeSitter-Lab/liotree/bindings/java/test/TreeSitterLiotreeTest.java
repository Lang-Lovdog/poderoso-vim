import io.github.treesitter.jtreesitter.Language;
import io.github.treesitter.jtreesitter.liotree.TreeSitterLiotree;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

public class TreeSitterLiotreeTest {
    @Test
    public void testCanLoadLanguage() {
        assertDoesNotThrow(() -> new Language(TreeSitterLiotree.language()));
    }
}
