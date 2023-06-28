package com.company;

import java.util.ArrayList;
import java.util.concurrent.Semaphore;

public class Manager {

    public Semaphore access;
    public Semaphore full;
    public Semaphore empty;

    public ArrayList<String> storage = new ArrayList<>();

    public int item_counter;

    public Manager(int storageSize) {
        access = new Semaphore(1);
        full = new Semaphore(storageSize);
        empty = new Semaphore(0);

        item_counter=0;
    }
}
