package main

import (
	"sync"
)

func routine(shared *int, waitGroup *sync.WaitGroup) {
	*shared = 3
	waitGroup.Done()
}

func main() {
	shared := 1
	var waitGroup sync.WaitGroup
	waitGroup.Add(1)
	go routine(&shared, &waitGroup)
	shared = 2
	waitGroup.Wait()
}
