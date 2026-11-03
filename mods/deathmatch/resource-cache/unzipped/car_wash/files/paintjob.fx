texture paintjobTexture;
 
technique TexReplace
{
	pass P0
	{
		Texture[0] = paintjobTexture;
	}
}