public with sharing class RBController{
	public RBController(){

		System.debug('Test text'); 
		System.debug('Test text2');
		System.debug('Test text Small Upate'); 
	}

	private void testConsole(){
		for (Integer i = 0; i < 50; i++){
			System.debug('Result = ' + Math.random() * 1245);
		}

		System.debug('Test text');
		System.debug('Test text2');
		System.debug('Test text Small Upate'); 
	}
}