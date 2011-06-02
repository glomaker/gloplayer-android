package net.dndigital.glo
{
	public final class GloError extends Error
	{
		public static const INVALID_GLO_FILE:GloError = new GloError("File can't be validated");
	}
}