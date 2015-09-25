package main

import (
	"fmt"
	"sync"
)

func routine(shared *int, waitGroup *sync.WaitGroup) {
	*shared = 3
	fmt.Printf("wrote 3\n")
	waitGroup.Done()
}

func main() {
	shared := 1
	var waitGroup sync.WaitGroup
	waitGroup.Add(1)
	go routine(&shared, &waitGroup)
	shared = 2
	fmt.Printf("wrote 2\n")
	waitGroup.Wait()
}
