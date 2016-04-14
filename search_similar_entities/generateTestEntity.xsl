<xsl:template match="/">
	<vce>
		<document vse-key="1" vse-key-normalized="vse-key-normalized" filetypes=" ">
			<content name="entityType">TestEntity</content>
			<content name="id">1</content>
			<content name="simpleAttr1">AAA</content>
			<content name="simpleAttr2">BBB</content>
			<content name="hierarchicalAttr1">CCC1|CCC1_2|CCC1_3</content>
			<content name="hierarchicalAttr1">CCC2|CCC2_2|CCC2_3</content>
		</document>
		<document vse-key="2" vse-key-normalized="vse-key-normalized" filetypes=" ">
			<content name="entityType">TestEntity</content>
			<content name="id">2</content>
			<content name="simpleAttr1">AAA</content>
			<content name="simpleAttr2">BBB</content>
			<content name="hierarchicalAttr1">CCC1|CCC1_2|CCC1_3</content>
			<content name="hierarchicalAttr1">CCC2|CCC2_2|CCC2_3</content>
		</document>
	</vce>
</xsl:template>