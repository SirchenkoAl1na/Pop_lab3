package com.company;

public class Main {

    public static void main(String[] args) {
        Main main = new Main();
        int storageSize = 5;
        int itemNumbers = 20;
        int num_consumers=4;
        int num_producers=8;
        main.starter(storageSize, itemNumbers,num_consumers,num_producers);
    }

    private void starter(int storageSize, int itemNumbers,int num_consumers,int num_producers) {
        Manager manager = new Manager(storageSize);
        for (int i=0;i<num_consumers;i++){
            int itemNumbersForOneConsumer=(i != num_consumers - 1) ? itemNumbers / num_consumers 
            : itemNumbers - (i * (itemNumbers / num_consumers));
            new Consumer(itemNumbersForOneConsumer, manager,"Consumer#" + i);
        }
        for (int i=0;i<num_producers;i++){
            int itemNumbersForOneProducer=(i != num_producers - 1) ? itemNumbers / num_producers 
            : itemNumbers - (i * (itemNumbers / num_producers));
            new Producer(itemNumbersForOneProducer, manager,"Producer#" + i);

        }
    }
}
