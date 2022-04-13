A suitable environment for interacting with Pivotal Cloud Foundery


A very convinient way to use this enviroment is to make an alias for executing it.

You can do that in a couple of different ways:

1) `alias pcf='docker run -it -v $PWD:/persist –pull always --rm dukekautington/pcf_client zsh’` #Docker: Just install docker locally 
2) `alias pcf='kubectl run -it --rm=true  pcf --image=dukekautington/pcf_client -- /bin/zsh'` #K8s:  Use a preexisting K8s enviroment 

Then `pcf`

You also want to put that alias command near the end of your .bashrc or .zshrc file for a longer life.
