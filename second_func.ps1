begin
{
	function second_fun
	{
		write-warning "in second function"
	}
}
process
{
	second_fun
}
end { }