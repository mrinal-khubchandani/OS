
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 76 10 80       	push   $0x80107640
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 c5 47 00 00       	call   80104820 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 76 10 80       	push   $0x80107647
80100097:	50                   	push   %eax
80100098:	e8 53 46 00 00       	call   801046f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 77 48 00 00       	call   80104960 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 b9 48 00 00       	call   80104a20 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 45 00 00       	call   80104730 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 4e 76 10 80       	push   $0x8010764e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 46 00 00       	call   801047d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 76 10 80       	push   $0x8010765f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 45 00 00       	call   801047d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 45 00 00       	call   80104790 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 50 47 00 00       	call   80104960 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 bf 47 00 00       	jmp    80104a20 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 76 10 80       	push   $0x80107666
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 cf 46 00 00       	call   80104960 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 36 3d 00 00       	call   80104000 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 90 35 00 00       	call   80103870 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 2c 47 00 00       	call   80104a20 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 ce 46 00 00       	call   80104a20 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 6d 76 10 80       	push   $0x8010766d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 67 80 10 80 	movl   $0x80108067,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 44 00 00       	call   80104840 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 76 10 80       	push   $0x80107681
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 11 5e 00 00       	call   80106250 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 5f 5d 00 00       	call   80106250 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 53 5d 00 00       	call   80106250 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 47 5d 00 00       	call   80106250 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 f7 45 00 00       	call   80104b20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 2a 45 00 00       	call   80104a70 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 76 10 80       	push   $0x80107685
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 b0 76 10 80 	movzbl -0x7fef8950(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 40 43 00 00       	call   80104960 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 d4 43 00 00       	call   80104a20 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 fc 42 00 00       	call   80104a20 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 98 76 10 80       	mov    $0x80107698,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 6b 41 00 00       	call   80104960 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 76 10 80       	push   $0x8010769f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 38 41 00 00       	call   80104960 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100856:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 93 41 00 00       	call   80104a20 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100911:	68 c0 0f 11 80       	push   $0x80110fc0
80100916:	e8 e5 39 00 00       	call   80104300 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010093d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100964:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 44 3a 00 00       	jmp    801043e0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 a8 76 10 80       	push   $0x801076a8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 4b 3e 00 00       	call   80104820 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 4f 2e 00 00       	call   80103870 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 07 69 00 00       	call   801073a0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 c5 66 00 00       	call   801071c0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 d3 65 00 00       	call   80107100 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 a9 67 00 00       	call   80107320 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 11 66 00 00       	call   801071c0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 5a 67 00 00       	call   80107320 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 c1 76 10 80       	push   $0x801076c1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 35 68 00 00       	call   80107440 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 52 40 00 00       	call   80104c90 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 3f 40 00 00       	call   80104c90 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 3e 69 00 00       	call   801075a0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 d4 68 00 00       	call   801075a0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 41 3f 00 00       	call   80104c50 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 37 62 00 00       	call   80106f70 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 df 65 00 00       	call   80107320 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 cd 76 10 80       	push   $0x801076cd
80100d6b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d70:	e8 ab 3a 00 00       	call   80104820 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 0f 11 80       	push   $0x80110fe0
80100d91:	e8 ca 3b 00 00       	call   80104960 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 0f 11 80       	push   $0x80110fe0
80100dc1:	e8 5a 3c 00 00       	call   80104a20 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 0f 11 80       	push   $0x80110fe0
80100dda:	e8 41 3c 00 00       	call   80104a20 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 0f 11 80       	push   $0x80110fe0
80100dff:	e8 5c 3b 00 00       	call   80104960 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 0f 11 80       	push   $0x80110fe0
80100e1c:	e8 ff 3b 00 00       	call   80104a20 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 d4 76 10 80       	push   $0x801076d4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e51:	e8 0a 3b 00 00       	call   80104960 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 9f 3b 00 00       	jmp    80104a20 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 73 3b 00 00       	call   80104a20 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 dc 76 10 80       	push   $0x801076dc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 e6 76 10 80       	push   $0x801076e6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 ef 76 10 80       	push   $0x801076ef
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 f5 76 10 80       	push   $0x801076f5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 ff 76 10 80       	push   $0x801076ff
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 f8 19 11 80    	add    0x801119f8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 e0 19 11 80       	mov    0x801119e0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 12 77 10 80       	push   $0x80107712
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 06 38 00 00       	call   80104a70 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 00 1a 11 80       	push   $0x80111a00
801012aa:	e8 b1 36 00 00       	call   80104960 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 00 1a 11 80       	push   $0x80111a00
8010130f:	e8 0c 37 00 00       	call   80104a20 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 de 36 00 00       	call   80104a20 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 28 77 10 80       	push   $0x80107728
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 38 77 10 80       	push   $0x80107738
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 ba 36 00 00       	call   80104b20 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 4b 77 10 80       	push   $0x8010774b
80101491:	68 00 1a 11 80       	push   $0x80111a00
80101496:	e8 85 33 00 00       	call   80104820 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 52 77 10 80       	push   $0x80107752
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 3c 32 00 00       	call   801046f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 e0 19 11 80       	push   $0x801119e0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 f8 19 11 80    	pushl  0x801119f8
801014d5:	ff 35 f4 19 11 80    	pushl  0x801119f4
801014db:	ff 35 f0 19 11 80    	pushl  0x801119f0
801014e1:	ff 35 ec 19 11 80    	pushl  0x801119ec
801014e7:	ff 35 e8 19 11 80    	pushl  0x801119e8
801014ed:	ff 35 e4 19 11 80    	pushl  0x801119e4
801014f3:	ff 35 e0 19 11 80    	pushl  0x801119e0
801014f9:	68 b8 77 10 80       	push   $0x801077b8
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 dd 34 00 00       	call   80104a70 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 58 77 10 80       	push   $0x80107758
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 ea 34 00 00       	call   80104b20 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 00 1a 11 80       	push   $0x80111a00
8010165f:	e8 fc 32 00 00       	call   80104960 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010166f:	e8 ac 33 00 00       	call   80104a20 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 89 30 00 00       	call   80104730 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 03 34 00 00       	call   80104b20 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 70 77 10 80       	push   $0x80107770
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 6a 77 10 80       	push   $0x8010776a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 58 30 00 00       	call   801047d0 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 fc 2f 00 00       	jmp    80104790 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 7f 77 10 80       	push   $0x8010777f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 6b 2f 00 00       	call   80104730 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 b1 2f 00 00       	call   80104790 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017e6:	e8 75 31 00 00       	call   80104960 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 1b 32 00 00       	jmp    80104a20 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 00 1a 11 80       	push   $0x80111a00
80101810:	e8 4b 31 00 00       	call   80104960 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010181f:	e8 fc 31 00 00       	call   80104a20 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 14 31 00 00       	call   80104b20 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 18 30 00 00       	call   80104b20 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 ed 2f 00 00       	call   80104b90 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 8e 2f 00 00       	call   80104b90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 99 77 10 80       	push   $0x80107799
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 87 77 10 80       	push   $0x80107787
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 f2 1b 00 00       	call   80103870 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 00 1a 11 80       	push   $0x80111a00
80101c89:	e8 d2 2c 00 00       	call   80104960 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c99:	e8 82 2d 00 00       	call   80104a20 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 26 2e 00 00       	call   80104b20 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 93 2d 00 00       	call   80104b20 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 6e 2d 00 00       	call   80104bf0 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 a8 77 10 80       	push   $0x801077a8
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 4e 7e 10 80       	push   $0x80107e4e
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 14 78 10 80       	push   $0x80107814
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 0b 78 10 80       	push   $0x8010780b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 26 78 10 80       	push   $0x80107826
8010200b:	68 80 b5 10 80       	push   $0x8010b580
80102010:	e8 0b 28 00 00       	call   80104820 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 00 39 11 80       	mov    0x80113900,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 80 b5 10 80       	push   $0x8010b580
8010208e:	e8 cd 28 00 00       	call   80104960 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 0a 22 00 00       	call   80104300 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 b5 10 80       	push   $0x8010b580
8010210f:	e8 0c 29 00 00       	call   80104a20 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 9d 26 00 00       	call   801047d0 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 b5 10 80       	push   $0x8010b580
80102168:	e8 f3 27 00 00       	call   80104960 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 b5 10 80       	push   $0x8010b580
801021b8:	53                   	push   %ebx
801021b9:	e8 42 1e 00 00       	call   80104000 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 45 28 00 00       	jmp    80104a20 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 40 78 10 80       	push   $0x80107840
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 2a 78 10 80       	push   $0x8010782a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 55 78 10 80       	push   $0x80107855
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 54 36 11 80       	mov    0x80113654,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 74 78 10 80       	push   $0x80107874
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb e8 6d 11 80    	cmp    $0x80116de8,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 29 27 00 00       	call   80104a70 <memset>

  if(kmem.use_lock)
80102347:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 98 36 11 80       	mov    0x80113698,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
80102360:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 a0 26 00 00       	jmp    80104a20 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 60 36 11 80       	push   $0x80113660
80102388:	e8 d3 25 00 00       	call   80104960 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 a6 78 10 80       	push   $0x801078a6
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 ac 78 10 80       	push   $0x801078ac
80102400:	68 60 36 11 80       	push   $0x80113660
80102405:	e8 16 24 00 00       	call   80104820 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 94 36 11 80       	mov    0x80113694,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 98 36 11 80    	mov    %edx,0x80113698
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 60 36 11 80       	push   $0x80113660
801024f3:	e8 68 24 00 00       	call   80104960 <acquire>
  r = kmem.freelist;
801024f8:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 60 36 11 80       	push   $0x80113660
80102521:	e8 fa 24 00 00       	call   80104a20 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 e0 79 10 80 	movzbl -0x7fef8620(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 e0 78 10 80 	movzbl -0x7fef8720(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 c0 78 10 80 	mov    -0x7fef8740(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 e0 79 10 80 	movzbl -0x7fef8620(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 84 21 00 00       	call   80104ac0 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102a44:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 b7 20 00 00       	call   80104b20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102aae:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 e0 7a 10 80       	push   $0x80107ae0
80102b0f:	68 a0 36 11 80       	push   $0x801136a0
80102b14:	e8 07 1d 00 00       	call   80104820 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102b32:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102b38:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 a0 36 11 80       	push   $0x801136a0
80102bab:	e8 b0 1d 00 00       	call   80104960 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 a0 36 11 80       	push   $0x801136a0
80102bc0:	68 a0 36 11 80       	push   $0x801136a0
80102bc5:	e8 36 14 00 00       	call   80104000 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102bdb:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102bf7:	68 a0 36 11 80       	push   $0x801136a0
80102bfc:	e8 1f 1e 00 00       	call   80104a20 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 a0 36 11 80       	push   $0x801136a0
80102c1e:	e8 3d 1d 00 00       	call   80104960 <acquire>
  log.outstanding -= 1;
80102c23:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102c28:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 a0 36 11 80       	push   $0x801136a0
80102c5c:	e8 bf 1d 00 00       	call   80104a20 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102c96:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 65 1e 00 00       	call   80104b20 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 a0 36 11 80       	push   $0x801136a0
80102cff:	e8 5c 1c 00 00       	call   80104960 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102d0b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 e6 15 00 00       	call   80104300 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d21:	e8 fa 1c 00 00       	call   80104a20 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 a0 36 11 80       	push   $0x801136a0
80102d40:	e8 bb 15 00 00       	call   80104300 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d4c:	e8 cf 1c 00 00       	call   80104a20 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 e4 7a 10 80       	push   $0x80107ae4
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 a0 36 11 80       	push   $0x801136a0
80102dae:	e8 ad 1b 00 00       	call   80104960 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 1e 1c 00 00       	jmp    80104a20 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 f3 7a 10 80       	push   $0x80107af3
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 09 7b 10 80       	push   $0x80107b09
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 04 0a 00 00       	call   80103850 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 fd 09 00 00       	call   80103850 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 24 7b 10 80       	push   $0x80107b24
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 89 2f 00 00       	call   80105df0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 74 09 00 00       	call   801037e0 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 b1 0c 00 00       	call   80103b30 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 c5 40 00 00       	call   80106f50 <switchkvm>
  seginit();
80102e8b:	e8 30 40 00 00       	call   80106ec0 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 e8 6d 11 80       	push   $0x80116de8
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 5a 45 00 00       	call   80107420 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 eb 3f 00 00       	call   80106ec0 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 a7 32 00 00       	call   80106190 <uartinit>
  pinit();         // process table
80102ee9:	e8 d2 08 00 00       	call   801037c0 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 7d 2e 00 00       	call   80105d70 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 8c b4 10 80       	push   $0x8010b48c
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 07 1c 00 00       	call   80104b20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 00 39 11 80 b0 	imul   $0xb0,0x80113900,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f2b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 9b 08 00 00       	call   801037e0 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f64:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 00 39 11 80 b0 	imul   $0xb0,0x80113900,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 e6 08 00 00       	call   801038a0 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 38 7b 10 80       	push   $0x80107b38
80102ff3:	56                   	push   %esi
80102ff4:	e8 c7 1a 00 00       	call   80104ac0 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 55 7b 10 80       	push   $0x80107b55
801030b1:	56                   	push   %esi
801030b2:	e8 09 1a 00 00       	call   80104ac0 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 7c 7b 10 80 	jmp    *-0x7fef8484(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d 00 39 11 80    	mov    0x80113900,%ecx
8010318e:	83 f9 01             	cmp    $0x1,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d 00 39 11 80    	mov    %ecx,0x80113900
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 3d 7b 10 80       	push   $0x80107b3d
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 5c 7b 10 80       	push   $0x80107b5c
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 90 7b 10 80       	push   $0x80107b90
80103300:	50                   	push   %eax
80103301:	e8 1a 15 00 00       	call   80104820 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 fc 15 00 00       	call   80104960 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 7c 0f 00 00       	call   80104300 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 77 16 00 00       	jmp    80104a20 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 37 0f 00 00       	call   80104300 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 47 16 00 00       	call   80104a20 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 5e 15 00 00       	call   80104960 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 a7 0e 00 00       	call   80104300 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 9e 0b 00 00       	call   80104000 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 e7 03 00 00       	call   80103870 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 87 15 00 00       	call   80104a20 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 18 0e 00 00       	call   80104300 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 30 15 00 00       	call   80104a20 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 4b 14 00 00       	call   80104960 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 b6 0a 00 00       	call   80104000 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 02 03 00 00       	call   80103870 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 9d 14 00 00       	call   80104a20 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 24 0d 00 00       	call   80104300 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 3c 14 00 00       	call   80104a20 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	56                   	push   %esi
80103604:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103605:	bb 94 39 11 80       	mov    $0x80113994,%ebx
  acquire(&ptable.lock);
8010360a:	83 ec 0c             	sub    $0xc,%esp
8010360d:	68 60 39 11 80       	push   $0x80113960
80103612:	e8 49 13 00 00       	call   80104960 <acquire>
80103617:	83 c4 10             	add    $0x10,%esp
8010361a:	eb 16                	jmp    80103632 <allocproc+0x32>
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103626:	81 fb 94 65 11 80    	cmp    $0x80116594,%ebx
8010362c:	0f 83 0e 01 00 00    	jae    80103740 <allocproc+0x140>
    if(p->state == UNUSED)
80103632:	8b 43 0c             	mov    0xc(%ebx),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103639:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010363e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103641:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103648:	8d 50 01             	lea    0x1(%eax),%edx
8010364b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010364e:	68 60 39 11 80       	push   $0x80113960
  p->pid = nextpid++;
80103653:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103659:	e8 c2 13 00 00       	call   80104a20 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010365e:	e8 5d ee ff ff       	call   801024c0 <kalloc>
80103663:	83 c4 10             	add    $0x10,%esp
80103666:	85 c0                	test   %eax,%eax
80103668:	89 c6                	mov    %eax,%esi
8010366a:	89 43 08             	mov    %eax,0x8(%ebx)
8010366d:	0f 84 e8 00 00 00    	je     8010375b <allocproc+0x15b>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103673:	8d 80 b4 0f 00 00    	lea    0xfb4(%eax),%eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  p->ctime = ticks;
  cprintf("process with id: %d created at time %d\n",p->pid,p->ctime);
80103679:	83 ec 04             	sub    $0x4,%esp
  p->priority = 60; // default is 60
  p->pqlvl = 0; //default
  p->canruntill = 100000;
  for(int i=0;i<5;i++) p->ticks[i]=0;
  p->lastrun = -1;
  sp -= sizeof *p->context;
8010367c:	81 c6 9c 0f 00 00    	add    $0xf9c,%esi
  sp -= sizeof *p->tf;
80103682:	89 43 18             	mov    %eax,0x18(%ebx)
  p->ctime = ticks;
80103685:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
  *(uint*)sp = (uint)trapret;
8010368a:	c7 46 14 62 5d 10 80 	movl   $0x80105d62,0x14(%esi)
  p->ctime = ticks;
80103691:	89 43 7c             	mov    %eax,0x7c(%ebx)
  cprintf("process with id: %d created at time %d\n",p->pid,p->ctime);
80103694:	50                   	push   %eax
80103695:	ff 73 10             	pushl  0x10(%ebx)
80103698:	68 98 7b 10 80       	push   $0x80107b98
8010369d:	e8 be cf ff ff       	call   80100660 <cprintf>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036a2:	83 c4 0c             	add    $0xc,%esp
  p->rtime = 0;
801036a5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801036ac:	00 00 00 
  p->etime = 1073741824;
801036af:	c7 83 80 00 00 00 00 	movl   $0x40000000,0x80(%ebx)
801036b6:	00 00 40 
  p->numrun = 0;
801036b9:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801036c0:	00 00 00 
  p->priority = 60; // default is 60
801036c3:	c7 83 88 00 00 00 3c 	movl   $0x3c,0x88(%ebx)
801036ca:	00 00 00 
  p->pqlvl = 0; //default
801036cd:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801036d4:	00 00 00 
  p->canruntill = 100000;
801036d7:	c7 83 90 00 00 00 a0 	movl   $0x186a0,0x90(%ebx)
801036de:	86 01 00 
  for(int i=0;i<5;i++) p->ticks[i]=0;
801036e1:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801036e8:	00 00 00 
801036eb:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801036f2:	00 00 00 
801036f5:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
801036fc:	00 00 00 
801036ff:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
80103706:	00 00 00 
80103709:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80103710:	00 00 00 
  p->lastrun = -1;
80103713:	c7 83 ac 00 00 00 ff 	movl   $0xffffffff,0xac(%ebx)
8010371a:	ff ff ff 
  p->context = (struct context*)sp;
8010371d:	89 73 1c             	mov    %esi,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103720:	6a 14                	push   $0x14
80103722:	6a 00                	push   $0x0
80103724:	56                   	push   %esi
80103725:	e8 46 13 00 00       	call   80104a70 <memset>
  p->context->eip = (uint)forkret;
8010372a:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010372d:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103730:	c7 40 10 70 37 10 80 	movl   $0x80103770,0x10(%eax)
}
80103737:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010373a:	89 d8                	mov    %ebx,%eax
8010373c:	5b                   	pop    %ebx
8010373d:	5e                   	pop    %esi
8010373e:	5d                   	pop    %ebp
8010373f:	c3                   	ret    
  release(&ptable.lock);
80103740:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103743:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103745:	68 60 39 11 80       	push   $0x80113960
8010374a:	e8 d1 12 00 00       	call   80104a20 <release>
  return 0;
8010374f:	83 c4 10             	add    $0x10,%esp
}
80103752:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103755:	89 d8                	mov    %ebx,%eax
80103757:	5b                   	pop    %ebx
80103758:	5e                   	pop    %esi
80103759:	5d                   	pop    %ebp
8010375a:	c3                   	ret    
    p->state = UNUSED;
8010375b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103762:	31 db                	xor    %ebx,%ebx
80103764:	eb d1                	jmp    80103737 <allocproc+0x137>
80103766:	8d 76 00             	lea    0x0(%esi),%esi
80103769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103770 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103776:	68 60 39 11 80       	push   $0x80113960
8010377b:	e8 a0 12 00 00       	call   80104a20 <release>

  if (first) {
80103780:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103785:	83 c4 10             	add    $0x10,%esp
80103788:	85 c0                	test   %eax,%eax
8010378a:	75 04                	jne    80103790 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010378c:	c9                   	leave  
8010378d:	c3                   	ret    
8010378e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103790:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103793:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010379a:	00 00 00 
    iinit(ROOTDEV);
8010379d:	6a 01                	push   $0x1
8010379f:	e8 dc dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801037a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037ab:	e8 50 f3 ff ff       	call   80102b00 <initlog>
801037b0:	83 c4 10             	add    $0x10,%esp
}
801037b3:	c9                   	leave  
801037b4:	c3                   	ret    
801037b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037c0 <pinit>:
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037c6:	68 4b 7c 10 80       	push   $0x80107c4b
801037cb:	68 60 39 11 80       	push   $0x80113960
801037d0:	e8 4b 10 00 00       	call   80104820 <initlock>
}
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	c9                   	leave  
801037d9:	c3                   	ret    
801037da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037e0 <mycpu>:
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037e6:	9c                   	pushf  
801037e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037e8:	f6 c4 02             	test   $0x2,%ah
801037eb:	75 4a                	jne    80103837 <mycpu+0x57>
  apicid = lapicid();
801037ed:	e8 3e ef ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801037f2:	8b 15 00 39 11 80    	mov    0x80113900,%edx
801037f8:	85 d2                	test   %edx,%edx
801037fa:	7e 1b                	jle    80103817 <mycpu+0x37>
    if (cpus[i].apicid == apicid)
801037fc:	0f b6 0d a0 37 11 80 	movzbl 0x801137a0,%ecx
80103803:	39 c8                	cmp    %ecx,%eax
80103805:	74 21                	je     80103828 <mycpu+0x48>
  for (i = 0; i < ncpu; ++i) {
80103807:	83 fa 01             	cmp    $0x1,%edx
8010380a:	74 0b                	je     80103817 <mycpu+0x37>
    if (cpus[i].apicid == apicid)
8010380c:	0f b6 15 50 38 11 80 	movzbl 0x80113850,%edx
80103813:	39 d0                	cmp    %edx,%eax
80103815:	74 19                	je     80103830 <mycpu+0x50>
  panic("unknown apicid\n");
80103817:	83 ec 0c             	sub    $0xc,%esp
8010381a:	68 52 7c 10 80       	push   $0x80107c52
8010381f:	e8 6c cb ff ff       	call   80100390 <panic>
80103824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (cpus[i].apicid == apicid)
80103828:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
}
8010382d:	c9                   	leave  
8010382e:	c3                   	ret    
8010382f:	90                   	nop
    if (cpus[i].apicid == apicid)
80103830:	b8 50 38 11 80       	mov    $0x80113850,%eax
}
80103835:	c9                   	leave  
80103836:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
80103837:	83 ec 0c             	sub    $0xc,%esp
8010383a:	68 c0 7b 10 80       	push   $0x80107bc0
8010383f:	e8 4c cb ff ff       	call   80100390 <panic>
80103844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010384a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103850 <cpuid>:
cpuid() {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103856:	e8 85 ff ff ff       	call   801037e0 <mycpu>
8010385b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103860:	c9                   	leave  
  return mycpu()-cpus;
80103861:	c1 f8 04             	sar    $0x4,%eax
80103864:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010386a:	c3                   	ret    
8010386b:	90                   	nop
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103870 <myproc>:
myproc(void) {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	53                   	push   %ebx
80103874:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103877:	e8 14 10 00 00       	call   80104890 <pushcli>
  c = mycpu();
8010387c:	e8 5f ff ff ff       	call   801037e0 <mycpu>
  p = c->proc;
80103881:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103887:	e8 44 10 00 00       	call   801048d0 <popcli>
}
8010388c:	83 c4 04             	add    $0x4,%esp
8010388f:	89 d8                	mov    %ebx,%eax
80103891:	5b                   	pop    %ebx
80103892:	5d                   	pop    %ebp
80103893:	c3                   	ret    
80103894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010389a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038a0 <userinit>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801038a7:	e8 54 fd ff ff       	call   80103600 <allocproc>
801038ac:	89 c3                	mov    %eax,%ebx
  initproc = p;
801038ae:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801038b3:	e8 e8 3a 00 00       	call   801073a0 <setupkvm>
801038b8:	85 c0                	test   %eax,%eax
801038ba:	89 43 04             	mov    %eax,0x4(%ebx)
801038bd:	0f 84 bd 00 00 00    	je     80103980 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038c3:	83 ec 04             	sub    $0x4,%esp
801038c6:	68 2c 00 00 00       	push   $0x2c
801038cb:	68 60 b4 10 80       	push   $0x8010b460
801038d0:	50                   	push   %eax
801038d1:	e8 aa 37 00 00       	call   80107080 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038d6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038d9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038df:	6a 4c                	push   $0x4c
801038e1:	6a 00                	push   $0x0
801038e3:	ff 73 18             	pushl  0x18(%ebx)
801038e6:	e8 85 11 00 00       	call   80104a70 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038eb:	8b 43 18             	mov    0x18(%ebx),%eax
801038ee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038f3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038f8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038fb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103902:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103906:	8b 43 18             	mov    0x18(%ebx),%eax
80103909:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010390d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103911:	8b 43 18             	mov    0x18(%ebx),%eax
80103914:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103918:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010391c:	8b 43 18             	mov    0x18(%ebx),%eax
8010391f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103926:	8b 43 18             	mov    0x18(%ebx),%eax
80103929:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103930:	8b 43 18             	mov    0x18(%ebx),%eax
80103933:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010393a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010393d:	6a 10                	push   $0x10
8010393f:	68 7b 7c 10 80       	push   $0x80107c7b
80103944:	50                   	push   %eax
80103945:	e8 06 13 00 00       	call   80104c50 <safestrcpy>
  p->cwd = namei("/");
8010394a:	c7 04 24 84 7c 10 80 	movl   $0x80107c84,(%esp)
80103951:	e8 8a e5 ff ff       	call   80101ee0 <namei>
80103956:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103959:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80103960:	e8 fb 0f 00 00       	call   80104960 <acquire>
  p->state = RUNNABLE;
80103965:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010396c:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80103973:	e8 a8 10 00 00       	call   80104a20 <release>
}
80103978:	83 c4 10             	add    $0x10,%esp
8010397b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397e:	c9                   	leave  
8010397f:	c3                   	ret    
    panic("userinit: out of memory?");
80103980:	83 ec 0c             	sub    $0xc,%esp
80103983:	68 62 7c 10 80       	push   $0x80107c62
80103988:	e8 03 ca ff ff       	call   80100390 <panic>
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

80103990 <growproc>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	56                   	push   %esi
80103994:	53                   	push   %ebx
80103995:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103998:	e8 f3 0e 00 00       	call   80104890 <pushcli>
  c = mycpu();
8010399d:	e8 3e fe ff ff       	call   801037e0 <mycpu>
  p = c->proc;
801039a2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a8:	e8 23 0f 00 00       	call   801048d0 <popcli>
  if(n > 0){
801039ad:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801039b0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801039b2:	7f 1c                	jg     801039d0 <growproc+0x40>
  } else if(n < 0){
801039b4:	75 3a                	jne    801039f0 <growproc+0x60>
  switchuvm(curproc);
801039b6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801039b9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039bb:	53                   	push   %ebx
801039bc:	e8 af 35 00 00       	call   80106f70 <switchuvm>
  return 0;
801039c1:	83 c4 10             	add    $0x10,%esp
801039c4:	31 c0                	xor    %eax,%eax
}
801039c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039c9:	5b                   	pop    %ebx
801039ca:	5e                   	pop    %esi
801039cb:	5d                   	pop    %ebp
801039cc:	c3                   	ret    
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039d0:	83 ec 04             	sub    $0x4,%esp
801039d3:	01 c6                	add    %eax,%esi
801039d5:	56                   	push   %esi
801039d6:	50                   	push   %eax
801039d7:	ff 73 04             	pushl  0x4(%ebx)
801039da:	e8 e1 37 00 00       	call   801071c0 <allocuvm>
801039df:	83 c4 10             	add    $0x10,%esp
801039e2:	85 c0                	test   %eax,%eax
801039e4:	75 d0                	jne    801039b6 <growproc+0x26>
      return -1;
801039e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039eb:	eb d9                	jmp    801039c6 <growproc+0x36>
801039ed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039f0:	83 ec 04             	sub    $0x4,%esp
801039f3:	01 c6                	add    %eax,%esi
801039f5:	56                   	push   %esi
801039f6:	50                   	push   %eax
801039f7:	ff 73 04             	pushl  0x4(%ebx)
801039fa:	e8 f1 38 00 00       	call   801072f0 <deallocuvm>
801039ff:	83 c4 10             	add    $0x10,%esp
80103a02:	85 c0                	test   %eax,%eax
80103a04:	75 b0                	jne    801039b6 <growproc+0x26>
80103a06:	eb de                	jmp    801039e6 <growproc+0x56>
80103a08:	90                   	nop
80103a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a10 <fork>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	53                   	push   %ebx
80103a16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a19:	e8 72 0e 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103a1e:	e8 bd fd ff ff       	call   801037e0 <mycpu>
  p = c->proc;
80103a23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a29:	e8 a2 0e 00 00       	call   801048d0 <popcli>
  if((np = allocproc()) == 0){
80103a2e:	e8 cd fb ff ff       	call   80103600 <allocproc>
80103a33:	85 c0                	test   %eax,%eax
80103a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a38:	0f 84 b7 00 00 00    	je     80103af5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a3e:	83 ec 08             	sub    $0x8,%esp
80103a41:	ff 33                	pushl  (%ebx)
80103a43:	ff 73 04             	pushl  0x4(%ebx)
80103a46:	89 c7                	mov    %eax,%edi
80103a48:	e8 23 3a 00 00       	call   80107470 <copyuvm>
80103a4d:	83 c4 10             	add    $0x10,%esp
80103a50:	85 c0                	test   %eax,%eax
80103a52:	89 47 04             	mov    %eax,0x4(%edi)
80103a55:	0f 84 a1 00 00 00    	je     80103afc <fork+0xec>
  np->sz = curproc->sz;
80103a5b:	8b 03                	mov    (%ebx),%eax
80103a5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a60:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103a62:	89 59 14             	mov    %ebx,0x14(%ecx)
80103a65:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103a67:	8b 79 18             	mov    0x18(%ecx),%edi
80103a6a:	8b 73 18             	mov    0x18(%ebx),%esi
80103a6d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a76:	8b 40 18             	mov    0x18(%eax),%eax
80103a79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103a80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a84:	85 c0                	test   %eax,%eax
80103a86:	74 13                	je     80103a9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a88:	83 ec 0c             	sub    $0xc,%esp
80103a8b:	50                   	push   %eax
80103a8c:	e8 5f d3 ff ff       	call   80100df0 <filedup>
80103a91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a94:	83 c4 10             	add    $0x10,%esp
80103a97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a9b:	83 c6 01             	add    $0x1,%esi
80103a9e:	83 fe 10             	cmp    $0x10,%esi
80103aa1:	75 dd                	jne    80103a80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103aa3:	83 ec 0c             	sub    $0xc,%esp
80103aa6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aa9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103aac:	e8 9f db ff ff       	call   80101650 <idup>
80103ab1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ab4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ab7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aba:	8d 47 6c             	lea    0x6c(%edi),%eax
80103abd:	6a 10                	push   $0x10
80103abf:	53                   	push   %ebx
80103ac0:	50                   	push   %eax
80103ac1:	e8 8a 11 00 00       	call   80104c50 <safestrcpy>
  pid = np->pid;
80103ac6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ac9:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80103ad0:	e8 8b 0e 00 00       	call   80104960 <acquire>
  np->state = RUNNABLE;
80103ad5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103adc:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80103ae3:	e8 38 0f 00 00       	call   80104a20 <release>
  return pid;
80103ae8:	83 c4 10             	add    $0x10,%esp
}
80103aeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aee:	89 d8                	mov    %ebx,%eax
80103af0:	5b                   	pop    %ebx
80103af1:	5e                   	pop    %esi
80103af2:	5f                   	pop    %edi
80103af3:	5d                   	pop    %ebp
80103af4:	c3                   	ret    
    return -1;
80103af5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103afa:	eb ef                	jmp    80103aeb <fork+0xdb>
    kfree(np->kstack);
80103afc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103aff:	83 ec 0c             	sub    $0xc,%esp
80103b02:	ff 73 08             	pushl  0x8(%ebx)
80103b05:	e8 06 e8 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103b0a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b11:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b18:	83 c4 10             	add    $0x10,%esp
80103b1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b20:	eb c9                	jmp    80103aeb <fork+0xdb>
80103b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b30 <scheduler>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103b39:	e8 a2 fc ff ff       	call   801037e0 <mycpu>
80103b3e:	8d 70 04             	lea    0x4(%eax),%esi
80103b41:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103b43:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b4a:	00 00 00 
  asm volatile("sti");
80103b4d:	fb                   	sti    
    acquire(&ptable.lock);
80103b4e:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b51:	bf 94 39 11 80       	mov    $0x80113994,%edi
    acquire(&ptable.lock);
80103b56:	68 60 39 11 80       	push   $0x80113960
80103b5b:	e8 00 0e 00 00       	call   80104960 <acquire>
80103b60:	83 c4 10             	add    $0x10,%esp
80103b63:	eb 15                	jmp    80103b7a <scheduler+0x4a>
80103b65:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b68:	81 c7 b0 00 00 00    	add    $0xb0,%edi
80103b6e:	81 ff 94 65 11 80    	cmp    $0x80116594,%edi
80103b74:	0f 83 3c 01 00 00    	jae    80103cb6 <scheduler+0x186>
        if(p->state != RUNNABLE) 
80103b7a:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103b7e:	75 e8                	jne    80103b68 <scheduler+0x38>
        for(struct proc *p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++)
80103b80:	b8 94 39 11 80       	mov    $0x80113994,%eax
80103b85:	8d 76 00             	lea    0x0(%esi),%esi
          if((p1->state == RUNNABLE) && (lp->pqlvl > p1->pqlvl)) lp = p1;
80103b88:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b8c:	75 0f                	jne    80103b9d <scheduler+0x6d>
80103b8e:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
80103b94:	39 8f 8c 00 00 00    	cmp    %ecx,0x8c(%edi)
80103b9a:	0f 4f f8             	cmovg  %eax,%edi
        for(struct proc *p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++)
80103b9d:	05 b0 00 00 00       	add    $0xb0,%eax
80103ba2:	3d 94 65 11 80       	cmp    $0x80116594,%eax
80103ba7:	72 df                	jb     80103b88 <scheduler+0x58>
      c->proc = p;
80103ba9:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      p->numrun++;
80103baf:	83 87 94 00 00 00 01 	addl   $0x1,0x94(%edi)
      switchuvm(p);
80103bb6:	83 ec 0c             	sub    $0xc,%esp
      x1 = p->rtime;
80103bb9:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
      switchuvm(p);
80103bbf:	57                   	push   %edi
      x1 = p->rtime;
80103bc0:	a3 28 0f 11 80       	mov    %eax,0x80110f28
      switchuvm(p);
80103bc5:	e8 a6 33 00 00       	call   80106f70 <switchuvm>
      p->canruntill = tcrt[p->pqlvl];
80103bca:	8b 87 8c 00 00 00    	mov    0x8c(%edi),%eax
      int tcrt[] = {1,2,4,8};
80103bd0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
80103bd7:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
80103bde:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
80103be5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
      p->state = RUNNING;
80103bec:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      p->canruntill = tcrt[p->pqlvl];
80103bf3:	8b 44 85 d8          	mov    -0x28(%ebp,%eax,4),%eax
80103bf7:	89 87 90 00 00 00    	mov    %eax,0x90(%edi)
      swtch(&(c->scheduler), p->context);
80103bfd:	58                   	pop    %eax
80103bfe:	5a                   	pop    %edx
80103bff:	ff 77 1c             	pushl  0x1c(%edi)
80103c02:	56                   	push   %esi
80103c03:	e8 a3 10 00 00       	call   80104cab <swtch>
      switchkvm();
80103c08:	e8 43 33 00 00       	call   80106f50 <switchkvm>
      x1 = p->rtime - x1;
80103c0d:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
80103c13:	2b 05 28 0f 11 80    	sub    0x80110f28,%eax
        if(p->rtime>10 && p->pqlvl==0) 
80103c19:	83 c4 10             	add    $0x10,%esp
      x1 = p->rtime - x1;
80103c1c:	a3 28 0f 11 80       	mov    %eax,0x80110f28
      p->lastrun = ticks;
80103c21:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
80103c26:	89 87 ac 00 00 00    	mov    %eax,0xac(%edi)
      c->proc = 0;
80103c2c:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103c33:	00 00 00 
        if(p->rtime>10 && p->pqlvl==0) 
80103c36:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
80103c3c:	83 fa 0a             	cmp    $0xa,%edx
80103c3f:	7e 4f                	jle    80103c90 <scheduler+0x160>
80103c41:	8b 8f 8c 00 00 00    	mov    0x8c(%edi),%ecx
80103c47:	85 c9                	test   %ecx,%ecx
80103c49:	0f 85 9f 00 00 00    	jne    80103cee <scheduler+0x1be>
        if(p->rtime>50&&p->pqlvl==1) 
80103c4f:	83 fa 32             	cmp    $0x32,%edx
          p->pqlvl++;
80103c52:	c7 87 8c 00 00 00 01 	movl   $0x1,0x8c(%edi)
80103c59:	00 00 00 
        if(p->rtime>50&&p->pqlvl==1) 
80103c5c:	7e 32                	jle    80103c90 <scheduler+0x160>
        if(p->rtime>100&&p->pqlvl==2) 
80103c5e:	83 fa 64             	cmp    $0x64,%edx
          p->pqlvl++;
80103c61:	c7 87 8c 00 00 00 02 	movl   $0x2,0x8c(%edi)
80103c68:	00 00 00 
        if(p->rtime>100&&p->pqlvl==2) 
80103c6b:	7e 23                	jle    80103c90 <scheduler+0x160>
        if(p->rtime>200&&p->pqlvl==3) 
80103c6d:	81 fa c8 00 00 00    	cmp    $0xc8,%edx
          p->pqlvl++;
80103c73:	c7 87 8c 00 00 00 03 	movl   $0x3,0x8c(%edi)
80103c7a:	00 00 00 
        if(p->rtime>200&&p->pqlvl==3) 
80103c7d:	7e 11                	jle    80103c90 <scheduler+0x160>
          p->pqlvl++;
80103c7f:	c7 87 8c 00 00 00 04 	movl   $0x4,0x8c(%edi)
80103c86:	00 00 00 
80103c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        wt = ticks-(p->ctime);
80103c90:	2b 47 7c             	sub    0x7c(%edi),%eax
        if(wt>5000) 
80103c93:	3d 88 13 00 00       	cmp    $0x1388,%eax
80103c98:	7e 31                	jle    80103ccb <scheduler+0x19b>
          p->pqlvl=0;
80103c9a:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
80103ca1:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca4:	81 c7 b0 00 00 00    	add    $0xb0,%edi
80103caa:	81 ff 94 65 11 80    	cmp    $0x80116594,%edi
80103cb0:	0f 82 c4 fe ff ff    	jb     80103b7a <scheduler+0x4a>
    release(&ptable.lock);
80103cb6:	83 ec 0c             	sub    $0xc,%esp
80103cb9:	68 60 39 11 80       	push   $0x80113960
80103cbe:	e8 5d 0d 00 00       	call   80104a20 <release>
    sti();
80103cc3:	83 c4 10             	add    $0x10,%esp
80103cc6:	e9 82 fe ff ff       	jmp    80103b4d <scheduler+0x1d>
        else if((wt>2000)&&((p->pqlvl)>1)) 
80103ccb:	3d d0 07 00 00       	cmp    $0x7d0,%eax
80103cd0:	7e 56                	jle    80103d28 <scheduler+0x1f8>
80103cd2:	83 bf 8c 00 00 00 01 	cmpl   $0x1,0x8c(%edi)
80103cd9:	0f 8e 89 fe ff ff    	jle    80103b68 <scheduler+0x38>
          p->pqlvl=1;
80103cdf:	c7 87 8c 00 00 00 01 	movl   $0x1,0x8c(%edi)
80103ce6:	00 00 00 
80103ce9:	e9 7a fe ff ff       	jmp    80103b68 <scheduler+0x38>
        if(p->rtime>50&&p->pqlvl==1) 
80103cee:	83 fa 32             	cmp    $0x32,%edx
80103cf1:	7e 9d                	jle    80103c90 <scheduler+0x160>
80103cf3:	83 f9 01             	cmp    $0x1,%ecx
80103cf6:	0f 84 62 ff ff ff    	je     80103c5e <scheduler+0x12e>
        if(p->rtime>100&&p->pqlvl==2) 
80103cfc:	83 fa 64             	cmp    $0x64,%edx
80103cff:	7e 8f                	jle    80103c90 <scheduler+0x160>
80103d01:	83 f9 02             	cmp    $0x2,%ecx
80103d04:	0f 84 63 ff ff ff    	je     80103c6d <scheduler+0x13d>
        if(p->rtime>200&&p->pqlvl==3) 
80103d0a:	81 fa c8 00 00 00    	cmp    $0xc8,%edx
80103d10:	0f 8e 7a ff ff ff    	jle    80103c90 <scheduler+0x160>
80103d16:	83 f9 03             	cmp    $0x3,%ecx
80103d19:	0f 85 71 ff ff ff    	jne    80103c90 <scheduler+0x160>
80103d1f:	e9 5b ff ff ff       	jmp    80103c7f <scheduler+0x14f>
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        else if((wt>1000)&&((p->pqlvl)>2)) 
80103d28:	3d e8 03 00 00       	cmp    $0x3e8,%eax
80103d2d:	7f 27                	jg     80103d56 <scheduler+0x226>
        else if((wt>600)&&((p->pqlvl)>3)) 
80103d2f:	3d 58 02 00 00       	cmp    $0x258,%eax
80103d34:	0f 8e 2e fe ff ff    	jle    80103b68 <scheduler+0x38>
80103d3a:	83 bf 8c 00 00 00 03 	cmpl   $0x3,0x8c(%edi)
80103d41:	0f 8e 21 fe ff ff    	jle    80103b68 <scheduler+0x38>
          p->pqlvl=3;
80103d47:	c7 87 8c 00 00 00 03 	movl   $0x3,0x8c(%edi)
80103d4e:	00 00 00 
80103d51:	e9 12 fe ff ff       	jmp    80103b68 <scheduler+0x38>
        else if((wt>1000)&&((p->pqlvl)>2)) 
80103d56:	83 bf 8c 00 00 00 02 	cmpl   $0x2,0x8c(%edi)
80103d5d:	0f 8e 05 fe ff ff    	jle    80103b68 <scheduler+0x38>
          p->pqlvl=2;
80103d63:	c7 87 8c 00 00 00 02 	movl   $0x2,0x8c(%edi)
80103d6a:	00 00 00 
80103d6d:	e9 f6 fd ff ff       	jmp    80103b68 <scheduler+0x38>
80103d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <sched>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
  pushcli();
80103d85:	e8 06 0b 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103d8a:	e8 51 fa ff ff       	call   801037e0 <mycpu>
  p = c->proc;
80103d8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d95:	e8 36 0b 00 00       	call   801048d0 <popcli>
  if(!holding(&ptable.lock))
80103d9a:	83 ec 0c             	sub    $0xc,%esp
80103d9d:	68 60 39 11 80       	push   $0x80113960
80103da2:	e8 89 0b 00 00       	call   80104930 <holding>
80103da7:	83 c4 10             	add    $0x10,%esp
80103daa:	85 c0                	test   %eax,%eax
80103dac:	74 4f                	je     80103dfd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dae:	e8 2d fa ff ff       	call   801037e0 <mycpu>
80103db3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dba:	75 68                	jne    80103e24 <sched+0xa4>
  if(p->state == RUNNING)
80103dbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103dc0:	74 55                	je     80103e17 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dc2:	9c                   	pushf  
80103dc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dc4:	f6 c4 02             	test   $0x2,%ah
80103dc7:	75 41                	jne    80103e0a <sched+0x8a>
  intena = mycpu()->intena;
80103dc9:	e8 12 fa ff ff       	call   801037e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103dd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dd7:	e8 04 fa ff ff       	call   801037e0 <mycpu>
80103ddc:	83 ec 08             	sub    $0x8,%esp
80103ddf:	ff 70 04             	pushl  0x4(%eax)
80103de2:	53                   	push   %ebx
80103de3:	e8 c3 0e 00 00       	call   80104cab <swtch>
  mycpu()->intena = intena;
80103de8:	e8 f3 f9 ff ff       	call   801037e0 <mycpu>
}
80103ded:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103df0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5d                   	pop    %ebp
80103dfc:	c3                   	ret    
    panic("sched ptable.lock");
80103dfd:	83 ec 0c             	sub    $0xc,%esp
80103e00:	68 86 7c 10 80       	push   $0x80107c86
80103e05:	e8 86 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 b2 7c 10 80       	push   $0x80107cb2
80103e12:	e8 79 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 a4 7c 10 80       	push   $0x80107ca4
80103e1f:	e8 6c c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103e24:	83 ec 0c             	sub    $0xc,%esp
80103e27:	68 98 7c 10 80       	push   $0x80107c98
80103e2c:	e8 5f c5 ff ff       	call   80100390 <panic>
80103e31:	eb 0d                	jmp    80103e40 <exit>
80103e33:	90                   	nop
80103e34:	90                   	nop
80103e35:	90                   	nop
80103e36:	90                   	nop
80103e37:	90                   	nop
80103e38:	90                   	nop
80103e39:	90                   	nop
80103e3a:	90                   	nop
80103e3b:	90                   	nop
80103e3c:	90                   	nop
80103e3d:	90                   	nop
80103e3e:	90                   	nop
80103e3f:	90                   	nop

80103e40 <exit>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e49:	e8 42 0a 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103e4e:	e8 8d f9 ff ff       	call   801037e0 <mycpu>
  p = c->proc;
80103e53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e59:	e8 72 0a 00 00       	call   801048d0 <popcli>
  if(curproc == initproc)
80103e5e:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80103e64:	8d 73 28             	lea    0x28(%ebx),%esi
80103e67:	8d 7b 68             	lea    0x68(%ebx),%edi
80103e6a:	0f 84 28 01 00 00    	je     80103f98 <exit+0x158>
    if(curproc->ofile[fd]){
80103e70:	8b 06                	mov    (%esi),%eax
80103e72:	85 c0                	test   %eax,%eax
80103e74:	74 12                	je     80103e88 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	50                   	push   %eax
80103e7a:	e8 c1 cf ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103e7f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e85:	83 c4 10             	add    $0x10,%esp
80103e88:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
80103e8b:	39 fe                	cmp    %edi,%esi
80103e8d:	75 e1                	jne    80103e70 <exit+0x30>
  begin_op();
80103e8f:	e8 0c ed ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80103e94:	83 ec 0c             	sub    $0xc,%esp
80103e97:	ff 73 68             	pushl  0x68(%ebx)
80103e9a:	e8 11 d9 ff ff       	call   801017b0 <iput>
  end_op();
80103e9f:	e8 6c ed ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80103ea4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103eab:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80103eb2:	e8 a9 0a 00 00       	call   80104960 <acquire>
  wakeup1(curproc->parent);
80103eb7:	8b 53 14             	mov    0x14(%ebx),%edx
80103eba:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ebd:	b8 94 39 11 80       	mov    $0x80113994,%eax
80103ec2:	eb 10                	jmp    80103ed4 <exit+0x94>
80103ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ec8:	05 b0 00 00 00       	add    $0xb0,%eax
80103ecd:	3d 94 65 11 80       	cmp    $0x80116594,%eax
80103ed2:	73 1e                	jae    80103ef2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103ed4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ed8:	75 ee                	jne    80103ec8 <exit+0x88>
80103eda:	3b 50 20             	cmp    0x20(%eax),%edx
80103edd:	75 e9                	jne    80103ec8 <exit+0x88>
      p->state = RUNNABLE;
80103edf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee6:	05 b0 00 00 00       	add    $0xb0,%eax
80103eeb:	3d 94 65 11 80       	cmp    $0x80116594,%eax
80103ef0:	72 e2                	jb     80103ed4 <exit+0x94>
      p->parent = initproc;
80103ef2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef8:	ba 94 39 11 80       	mov    $0x80113994,%edx
80103efd:	eb 0f                	jmp    80103f0e <exit+0xce>
80103eff:	90                   	nop
80103f00:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80103f06:	81 fa 94 65 11 80    	cmp    $0x80116594,%edx
80103f0c:	73 3a                	jae    80103f48 <exit+0x108>
    if(p->parent == curproc){
80103f0e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f11:	75 ed                	jne    80103f00 <exit+0xc0>
      if(p->state == ZOMBIE)
80103f13:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f17:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f1a:	75 e4                	jne    80103f00 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f1c:	b8 94 39 11 80       	mov    $0x80113994,%eax
80103f21:	eb 11                	jmp    80103f34 <exit+0xf4>
80103f23:	90                   	nop
80103f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f28:	05 b0 00 00 00       	add    $0xb0,%eax
80103f2d:	3d 94 65 11 80       	cmp    $0x80116594,%eax
80103f32:	73 cc                	jae    80103f00 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103f34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f38:	75 ee                	jne    80103f28 <exit+0xe8>
80103f3a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f3d:	75 e9                	jne    80103f28 <exit+0xe8>
      p->state = RUNNABLE;
80103f3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f46:	eb e0                	jmp    80103f28 <exit+0xe8>
  curproc->etime = ticks;
80103f48:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
80103f4d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  cprintf("process with pid %d ended at %d and ran for %d clocks\n",curproc->pid,curproc->etime,curproc->rtime);
80103f53:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80103f59:	50                   	push   %eax
80103f5a:	ff 73 10             	pushl  0x10(%ebx)
80103f5d:	68 e8 7b 10 80       	push   $0x80107be8
80103f62:	e8 f9 c6 ff ff       	call   80100660 <cprintf>
  cprintf("Process ended at pqlvl %d and priority %d\n",curproc->pqlvl,curproc->priority);
80103f67:	83 c4 0c             	add    $0xc,%esp
80103f6a:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80103f70:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80103f76:	68 20 7c 10 80       	push   $0x80107c20
80103f7b:	e8 e0 c6 ff ff       	call   80100660 <cprintf>
  curproc->state = ZOMBIE;
80103f80:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f87:	e8 f4 fd ff ff       	call   80103d80 <sched>
  panic("zombie exit");
80103f8c:	c7 04 24 d3 7c 10 80 	movl   $0x80107cd3,(%esp)
80103f93:	e8 f8 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f98:	83 ec 0c             	sub    $0xc,%esp
80103f9b:	68 c6 7c 10 80       	push   $0x80107cc6
80103fa0:	e8 eb c3 ff ff       	call   80100390 <panic>
80103fa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <yield>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	53                   	push   %ebx
80103fb4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103fb7:	68 60 39 11 80       	push   $0x80113960
80103fbc:	e8 9f 09 00 00       	call   80104960 <acquire>
  pushcli();
80103fc1:	e8 ca 08 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103fc6:	e8 15 f8 ff ff       	call   801037e0 <mycpu>
  p = c->proc;
80103fcb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fd1:	e8 fa 08 00 00       	call   801048d0 <popcli>
  myproc()->state = RUNNABLE;
80103fd6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103fdd:	e8 9e fd ff ff       	call   80103d80 <sched>
  release(&ptable.lock);
80103fe2:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80103fe9:	e8 32 0a 00 00       	call   80104a20 <release>
}
80103fee:	83 c4 10             	add    $0x10,%esp
80103ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff4:	c9                   	leave  
80103ff5:	c3                   	ret    
80103ff6:	8d 76 00             	lea    0x0(%esi),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <sleep>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	8b 7d 08             	mov    0x8(%ebp),%edi
8010400c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010400f:	e8 7c 08 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104014:	e8 c7 f7 ff ff       	call   801037e0 <mycpu>
  p = c->proc;
80104019:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010401f:	e8 ac 08 00 00       	call   801048d0 <popcli>
  if(p == 0)
80104024:	85 db                	test   %ebx,%ebx
80104026:	0f 84 87 00 00 00    	je     801040b3 <sleep+0xb3>
  if(lk == 0)
8010402c:	85 f6                	test   %esi,%esi
8010402e:	74 76                	je     801040a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104030:	81 fe 60 39 11 80    	cmp    $0x80113960,%esi
80104036:	74 50                	je     80104088 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104038:	83 ec 0c             	sub    $0xc,%esp
8010403b:	68 60 39 11 80       	push   $0x80113960
80104040:	e8 1b 09 00 00       	call   80104960 <acquire>
    release(lk);
80104045:	89 34 24             	mov    %esi,(%esp)
80104048:	e8 d3 09 00 00       	call   80104a20 <release>
  p->chan = chan;
8010404d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104050:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104057:	e8 24 fd ff ff       	call   80103d80 <sched>
  p->chan = 0;
8010405c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104063:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
8010406a:	e8 b1 09 00 00       	call   80104a20 <release>
    acquire(lk);
8010406f:	89 75 08             	mov    %esi,0x8(%ebp)
80104072:	83 c4 10             	add    $0x10,%esp
}
80104075:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104078:	5b                   	pop    %ebx
80104079:	5e                   	pop    %esi
8010407a:	5f                   	pop    %edi
8010407b:	5d                   	pop    %ebp
    acquire(lk);
8010407c:	e9 df 08 00 00       	jmp    80104960 <acquire>
80104081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104088:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010408b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104092:	e8 e9 fc ff ff       	call   80103d80 <sched>
  p->chan = 0;
80104097:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010409e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040a1:	5b                   	pop    %ebx
801040a2:	5e                   	pop    %esi
801040a3:	5f                   	pop    %edi
801040a4:	5d                   	pop    %ebp
801040a5:	c3                   	ret    
    panic("sleep without lk");
801040a6:	83 ec 0c             	sub    $0xc,%esp
801040a9:	68 e5 7c 10 80       	push   $0x80107ce5
801040ae:	e8 dd c2 ff ff       	call   80100390 <panic>
    panic("sleep");
801040b3:	83 ec 0c             	sub    $0xc,%esp
801040b6:	68 df 7c 10 80       	push   $0x80107cdf
801040bb:	e8 d0 c2 ff ff       	call   80100390 <panic>

801040c0 <wait>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
  pushcli();
801040c5:	e8 c6 07 00 00       	call   80104890 <pushcli>
  c = mycpu();
801040ca:	e8 11 f7 ff ff       	call   801037e0 <mycpu>
  p = c->proc;
801040cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040d5:	e8 f6 07 00 00       	call   801048d0 <popcli>
  acquire(&ptable.lock);
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 60 39 11 80       	push   $0x80113960
801040e2:	e8 79 08 00 00       	call   80104960 <acquire>
801040e7:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ea:	bb 94 39 11 80       	mov    $0x80113994,%ebx
    havekids = 0;
801040ef:	31 c0                	xor    %eax,%eax
801040f1:	eb 13                	jmp    80104106 <wait+0x46>
801040f3:	90                   	nop
801040f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801040fe:	81 fb 94 65 11 80    	cmp    $0x80116594,%ebx
80104104:	73 1e                	jae    80104124 <wait+0x64>
      if(p->parent != curproc)
80104106:	39 73 14             	cmp    %esi,0x14(%ebx)
80104109:	75 ed                	jne    801040f8 <wait+0x38>
      if(p->state == ZOMBIE){
8010410b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010410f:	74 37                	je     80104148 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104111:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80104117:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411c:	81 fb 94 65 11 80    	cmp    $0x80116594,%ebx
80104122:	72 e2                	jb     80104106 <wait+0x46>
    if(!havekids || curproc->killed){
80104124:	85 c0                	test   %eax,%eax
80104126:	74 76                	je     8010419e <wait+0xde>
80104128:	8b 46 24             	mov    0x24(%esi),%eax
8010412b:	85 c0                	test   %eax,%eax
8010412d:	75 6f                	jne    8010419e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010412f:	83 ec 08             	sub    $0x8,%esp
80104132:	68 60 39 11 80       	push   $0x80113960
80104137:	56                   	push   %esi
80104138:	e8 c3 fe ff ff       	call   80104000 <sleep>
  for(;;){
8010413d:	83 c4 10             	add    $0x10,%esp
80104140:	eb a8                	jmp    801040ea <wait+0x2a>
80104142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010414e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104151:	e8 ba e1 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80104156:	5a                   	pop    %edx
80104157:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010415a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104161:	e8 ba 31 00 00       	call   80107320 <freevm>
        release(&ptable.lock);
80104166:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
        p->pid = 0;
8010416d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104174:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010417b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010417f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104186:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010418d:	e8 8e 08 00 00       	call   80104a20 <release>
        return pid;
80104192:	83 c4 10             	add    $0x10,%esp
}
80104195:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104198:	89 f0                	mov    %esi,%eax
8010419a:	5b                   	pop    %ebx
8010419b:	5e                   	pop    %esi
8010419c:	5d                   	pop    %ebp
8010419d:	c3                   	ret    
      release(&ptable.lock);
8010419e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041a6:	68 60 39 11 80       	push   $0x80113960
801041ab:	e8 70 08 00 00       	call   80104a20 <release>
      return -1;
801041b0:	83 c4 10             	add    $0x10,%esp
801041b3:	eb e0                	jmp    80104195 <wait+0xd5>
801041b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041c0 <waitx>:
int waitx(int* wtime, int* rtime){
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	57                   	push   %edi
801041c4:	56                   	push   %esi
801041c5:	53                   	push   %ebx
801041c6:	83 ec 0c             	sub    $0xc,%esp
801041c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801041cc:	e8 bf 06 00 00       	call   80104890 <pushcli>
  c = mycpu();
801041d1:	e8 0a f6 ff ff       	call   801037e0 <mycpu>
  p = c->proc;
801041d6:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041dc:	e8 ef 06 00 00       	call   801048d0 <popcli>
  acquire(&ptable.lock);
801041e1:	83 ec 0c             	sub    $0xc,%esp
801041e4:	68 60 39 11 80       	push   $0x80113960
801041e9:	e8 72 07 00 00       	call   80104960 <acquire>
801041ee:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f1:	bb 94 39 11 80       	mov    $0x80113994,%ebx
    havekids = 0;
801041f6:	31 c0                	xor    %eax,%eax
801041f8:	eb 14                	jmp    8010420e <waitx+0x4e>
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104200:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104206:	81 fb 94 65 11 80    	cmp    $0x80116594,%ebx
8010420c:	73 1e                	jae    8010422c <waitx+0x6c>
      if(p->parent == curproc)
8010420e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104211:	75 ed                	jne    80104200 <waitx+0x40>
        if(p->state == ZOMBIE){
80104213:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104217:	74 3f                	je     80104258 <waitx+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104219:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
        havekids = 1;
8010421f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104224:	81 fb 94 65 11 80    	cmp    $0x80116594,%ebx
8010422a:	72 e2                	jb     8010420e <waitx+0x4e>
    if(!havekids || curproc->killed){
8010422c:	85 c0                	test   %eax,%eax
8010422e:	0f 84 a8 00 00 00    	je     801042dc <waitx+0x11c>
80104234:	8b 46 24             	mov    0x24(%esi),%eax
80104237:	85 c0                	test   %eax,%eax
80104239:	0f 85 9d 00 00 00    	jne    801042dc <waitx+0x11c>
    sleep(curproc, &ptable.lock);
8010423f:	83 ec 08             	sub    $0x8,%esp
80104242:	68 60 39 11 80       	push   $0x80113960
80104247:	56                   	push   %esi
80104248:	e8 b3 fd ff ff       	call   80104000 <sleep>
    havekids = 0;
8010424d:	83 c4 10             	add    $0x10,%esp
80104250:	eb 9f                	jmp    801041f1 <waitx+0x31>
80104252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          *rtime = p->rtime;
80104258:	8b 45 0c             	mov    0xc(%ebp),%eax
8010425b:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80104261:	89 10                	mov    %edx,(%eax)
          if(p->etime==1073741824){
80104263:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104269:	3d 00 00 00 40       	cmp    $0x40000000,%eax
8010426e:	74 63                	je     801042d3 <waitx+0x113>
            *wtime = (p->etime);
80104270:	89 07                	mov    %eax,(%edi)
          *wtime = *wtime - p->ctime - p->rtime;
80104272:	2b 43 7c             	sub    0x7c(%ebx),%eax
          kfree(p->kstack);
80104275:	83 ec 0c             	sub    $0xc,%esp
          *wtime = *wtime - p->ctime - p->rtime;
80104278:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
8010427e:	89 07                	mov    %eax,(%edi)
          kfree(p->kstack);
80104280:	6a 00                	push   $0x0
          pid = p->pid;
80104282:	8b 73 10             	mov    0x10(%ebx),%esi
          p->kstack = 0;
80104285:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
          kfree(p->kstack);
8010428c:	e8 7f e0 ff ff       	call   80102310 <kfree>
          freevm(p->pgdir);
80104291:	5a                   	pop    %edx
80104292:	ff 73 04             	pushl  0x4(%ebx)
          p->killed = 0;
80104295:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
          p->parent = 0;
8010429c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
          freevm(p->pgdir);
801042a3:	e8 78 30 00 00       	call   80107320 <freevm>
          release(&ptable.lock);
801042a8:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
          p->pid = 0;
801042af:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
          p->name[0] = 0;
801042b6:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
          p->state = UNUSED;
801042ba:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
          release(&ptable.lock);
801042c1:	e8 5a 07 00 00       	call   80104a20 <release>
          return pid;
801042c6:	83 c4 10             	add    $0x10,%esp
}
801042c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042cc:	89 f0                	mov    %esi,%eax
801042ce:	5b                   	pop    %ebx
801042cf:	5e                   	pop    %esi
801042d0:	5f                   	pop    %edi
801042d1:	5d                   	pop    %ebp
801042d2:	c3                   	ret    
            *wtime = (ticks);
801042d3:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
801042d8:	89 07                	mov    %eax,(%edi)
801042da:	eb 96                	jmp    80104272 <waitx+0xb2>
      release(&ptable.lock);
801042dc:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042df:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042e4:	68 60 39 11 80       	push   $0x80113960
801042e9:	e8 32 07 00 00       	call   80104a20 <release>
      return -1;
801042ee:	83 c4 10             	add    $0x10,%esp
801042f1:	eb d6                	jmp    801042c9 <waitx+0x109>
801042f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 10             	sub    $0x10,%esp
80104307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010430a:	68 60 39 11 80       	push   $0x80113960
8010430f:	e8 4c 06 00 00       	call   80104960 <acquire>
80104314:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104317:	b8 94 39 11 80       	mov    $0x80113994,%eax
8010431c:	eb 0e                	jmp    8010432c <wakeup+0x2c>
8010431e:	66 90                	xchg   %ax,%ax
80104320:	05 b0 00 00 00       	add    $0xb0,%eax
80104325:	3d 94 65 11 80       	cmp    $0x80116594,%eax
8010432a:	73 1e                	jae    8010434a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010432c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104330:	75 ee                	jne    80104320 <wakeup+0x20>
80104332:	3b 58 20             	cmp    0x20(%eax),%ebx
80104335:	75 e9                	jne    80104320 <wakeup+0x20>
      p->state = RUNNABLE;
80104337:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010433e:	05 b0 00 00 00       	add    $0xb0,%eax
80104343:	3d 94 65 11 80       	cmp    $0x80116594,%eax
80104348:	72 e2                	jb     8010432c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010434a:	c7 45 08 60 39 11 80 	movl   $0x80113960,0x8(%ebp)
}
80104351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104354:	c9                   	leave  
  release(&ptable.lock);
80104355:	e9 c6 06 00 00       	jmp    80104a20 <release>
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104360 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010436a:	68 60 39 11 80       	push   $0x80113960
8010436f:	e8 ec 05 00 00       	call   80104960 <acquire>
80104374:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104377:	b8 94 39 11 80       	mov    $0x80113994,%eax
8010437c:	eb 0e                	jmp    8010438c <kill+0x2c>
8010437e:	66 90                	xchg   %ax,%ax
80104380:	05 b0 00 00 00       	add    $0xb0,%eax
80104385:	3d 94 65 11 80       	cmp    $0x80116594,%eax
8010438a:	73 34                	jae    801043c0 <kill+0x60>
    if(p->pid == pid){
8010438c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010438f:	75 ef                	jne    80104380 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104391:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104395:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010439c:	75 07                	jne    801043a5 <kill+0x45>
        p->state = RUNNABLE;
8010439e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043a5:	83 ec 0c             	sub    $0xc,%esp
801043a8:	68 60 39 11 80       	push   $0x80113960
801043ad:	e8 6e 06 00 00       	call   80104a20 <release>
      return 0;
801043b2:	83 c4 10             	add    $0x10,%esp
801043b5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801043b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ba:	c9                   	leave  
801043bb:	c3                   	ret    
801043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801043c0:	83 ec 0c             	sub    $0xc,%esp
801043c3:	68 60 39 11 80       	push   $0x80113960
801043c8:	e8 53 06 00 00       	call   80104a20 <release>
  return -1;
801043cd:	83 c4 10             	add    $0x10,%esp
801043d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d8:	c9                   	leave  
801043d9:	c3                   	ret    
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e9:	bb 94 39 11 80       	mov    $0x80113994,%ebx
{
801043ee:	83 ec 3c             	sub    $0x3c,%esp
801043f1:	eb 27                	jmp    8010441a <procdump+0x3a>
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 67 80 10 80       	push   $0x80108067
80104400:	e8 5b c2 ff ff       	call   80100660 <cprintf>
80104405:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104408:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010440e:	81 fb 94 65 11 80    	cmp    $0x80116594,%ebx
80104414:	0f 83 86 00 00 00    	jae    801044a0 <procdump+0xc0>
    if(p->state == UNUSED)
8010441a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010441d:	85 c0                	test   %eax,%eax
8010441f:	74 e7                	je     80104408 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104421:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104424:	ba f6 7c 10 80       	mov    $0x80107cf6,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104429:	77 11                	ja     8010443c <procdump+0x5c>
8010442b:	8b 14 85 40 7d 10 80 	mov    -0x7fef82c0(,%eax,4),%edx
      state = "???";
80104432:	b8 f6 7c 10 80       	mov    $0x80107cf6,%eax
80104437:	85 d2                	test   %edx,%edx
80104439:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010443c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010443f:	50                   	push   %eax
80104440:	52                   	push   %edx
80104441:	ff 73 10             	pushl  0x10(%ebx)
80104444:	68 fa 7c 10 80       	push   $0x80107cfa
80104449:	e8 12 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010444e:	83 c4 10             	add    $0x10,%esp
80104451:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104455:	75 a1                	jne    801043f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104457:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010445a:	83 ec 08             	sub    $0x8,%esp
8010445d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104460:	50                   	push   %eax
80104461:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104464:	8b 40 0c             	mov    0xc(%eax),%eax
80104467:	83 c0 08             	add    $0x8,%eax
8010446a:	50                   	push   %eax
8010446b:	e8 d0 03 00 00       	call   80104840 <getcallerpcs>
80104470:	83 c4 10             	add    $0x10,%esp
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104478:	8b 17                	mov    (%edi),%edx
8010447a:	85 d2                	test   %edx,%edx
8010447c:	0f 84 76 ff ff ff    	je     801043f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104482:	83 ec 08             	sub    $0x8,%esp
80104485:	83 c7 04             	add    $0x4,%edi
80104488:	52                   	push   %edx
80104489:	68 81 76 10 80       	push   $0x80107681
8010448e:	e8 cd c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104493:	83 c4 10             	add    $0x10,%esp
80104496:	39 fe                	cmp    %edi,%esi
80104498:	75 de                	jne    80104478 <procdump+0x98>
8010449a:	e9 59 ff ff ff       	jmp    801043f8 <procdump+0x18>
8010449f:	90                   	nop
  }
}
801044a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044a3:	5b                   	pop    %ebx
801044a4:	5e                   	pop    %esi
801044a5:	5f                   	pop    %edi
801044a6:	5d                   	pop    %ebp
801044a7:	c3                   	ret    
801044a8:	90                   	nop
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044b0 <uprtime>:

// added functions
void uprtime() {
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  acquire(&ptable.lock);
801044b7:	68 60 39 11 80       	push   $0x80113960
801044bc:	e8 9f 04 00 00       	call   80104960 <acquire>
        p->canruntill--;
      #endif
    }
    #ifdef MLFQ
    else {
      int wt=ticks;
801044c1:	8b 1d e0 6d 11 80    	mov    0x80116de0,%ebx
801044c7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ca:	b8 94 39 11 80       	mov    $0x80113994,%eax
801044cf:	eb 6b                	jmp    8010453c <uprtime+0x8c>
801044d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      wt-=(p->lastrun);
801044d8:	89 d9                	mov    %ebx,%ecx
801044da:	2b 88 ac 00 00 00    	sub    0xac(%eax),%ecx
      if(p->pqlvl==1 && wt>100) 
801044e0:	83 f9 64             	cmp    $0x64,%ecx
801044e3:	7e 09                	jle    801044ee <uprtime+0x3e>
801044e5:	83 fa 01             	cmp    $0x1,%edx
801044e8:	0f 84 a2 00 00 00    	je     80104590 <uprtime+0xe0>
        p->pqlvl--;
      if(p->pqlvl==2 && wt>300) 
801044ee:	81 f9 2c 01 00 00    	cmp    $0x12c,%ecx
801044f4:	7e 09                	jle    801044ff <uprtime+0x4f>
801044f6:	83 fa 02             	cmp    $0x2,%edx
801044f9:	0f 84 81 00 00 00    	je     80104580 <uprtime+0xd0>
        p->pqlvl--;
      if(p->pqlvl==3 && wt>600) 
801044ff:	81 f9 58 02 00 00    	cmp    $0x258,%ecx
80104505:	7e 09                	jle    80104510 <uprtime+0x60>
80104507:	83 fa 03             	cmp    $0x3,%edx
8010450a:	0f 84 90 00 00 00    	je     801045a0 <uprtime+0xf0>
        p->pqlvl--;
      if(p->pqlvl==4 && wt>1000) 
80104510:	83 fa 04             	cmp    $0x4,%edx
80104513:	75 1b                	jne    80104530 <uprtime+0x80>
80104515:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
8010451b:	7e 13                	jle    80104530 <uprtime+0x80>
        p->pqlvl--;
8010451d:	c7 80 8c 00 00 00 03 	movl   $0x3,0x8c(%eax)
80104524:	00 00 00 
80104527:	89 f6                	mov    %esi,%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104530:	05 b0 00 00 00       	add    $0xb0,%eax
80104535:	3d 94 65 11 80       	cmp    $0x80116594,%eax
8010453a:	73 2e                	jae    8010456a <uprtime+0xba>
    if(p->state == RUNNING){
8010453c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104540:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80104546:	75 90                	jne    801044d8 <uprtime+0x28>
      p->ticks[p->pqlvl]++; 
80104548:	83 84 90 98 00 00 00 	addl   $0x1,0x98(%eax,%edx,4)
8010454f:	01 
      p->rtime++;
80104550:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
        p->canruntill--;
80104557:	83 a8 90 00 00 00 01 	subl   $0x1,0x90(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010455e:	05 b0 00 00 00       	add    $0xb0,%eax
80104563:	3d 94 65 11 80       	cmp    $0x80116594,%eax
80104568:	72 d2                	jb     8010453c <uprtime+0x8c>
    }
    #endif
  }
  release(&ptable.lock);
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 60 39 11 80       	push   $0x80113960
80104572:	e8 a9 04 00 00       	call   80104a20 <release>
}
80104577:	83 c4 10             	add    $0x10,%esp
8010457a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010457d:	c9                   	leave  
8010457e:	c3                   	ret    
8010457f:	90                   	nop
        p->pqlvl--;
80104580:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
80104587:	00 00 00 
8010458a:	eb a4                	jmp    80104530 <uprtime+0x80>
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->pqlvl--;
80104590:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104597:	00 00 00 
8010459a:	eb 94                	jmp    80104530 <uprtime+0x80>
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->pqlvl--;
801045a0:	c7 80 8c 00 00 00 02 	movl   $0x2,0x8c(%eax)
801045a7:	00 00 00 
801045aa:	e9 81 ff ff ff       	jmp    80104530 <uprtime+0x80>
801045af:	90                   	nop

801045b0 <getpinfo>:

// userproc
int getpinfo(int pid,struct proc_stat * ps){
801045b0:	55                   	push   %ebp
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045b1:	b8 94 39 11 80       	mov    $0x80113994,%eax
int getpinfo(int pid,struct proc_stat * ps){
801045b6:	89 e5                	mov    %esp,%ebp
801045b8:	53                   	push   %ebx
801045b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801045bc:	8b 55 0c             	mov    0xc(%ebp),%edx
    if(pid!=(p->pid))
801045bf:	39 48 10             	cmp    %ecx,0x10(%eax)
801045c2:	74 1c                	je     801045e0 <getpinfo+0x30>
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045c4:	05 b0 00 00 00       	add    $0xb0,%eax
801045c9:	3d 94 65 11 80       	cmp    $0x80116594,%eax
801045ce:	72 ef                	jb     801045bf <getpinfo+0xf>
    uproc.current_queue = p->pqlvl;
    uproc.num_run = p->numrun;

    return 0;
  }
  return -1;
801045d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045d5:	eb 7e                	jmp    80104655 <getpinfo+0xa5>
801045d7:	89 f6                	mov    %esi,%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ps->runtime = p->rtime;
801045e0:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
    ps->pid=pid;
801045e6:	89 0a                	mov    %ecx,(%edx)
    uproc.pid = ps->pid;
801045e8:	89 0d 20 39 11 80    	mov    %ecx,0x80113920
    ps->runtime = p->rtime;
801045ee:	89 5a 04             	mov    %ebx,0x4(%edx)
    ps->current_queue = p->pqlvl;
801045f1:	8b 98 8c 00 00 00    	mov    0x8c(%eax),%ebx
801045f7:	89 5a 0c             	mov    %ebx,0xc(%edx)
      ps->ticks[i]=p->ticks[i];
801045fa:	8b 98 98 00 00 00    	mov    0x98(%eax),%ebx
80104600:	89 5a 10             	mov    %ebx,0x10(%edx)
80104603:	8b 98 9c 00 00 00    	mov    0x9c(%eax),%ebx
80104609:	89 5a 14             	mov    %ebx,0x14(%edx)
8010460c:	8b 98 a0 00 00 00    	mov    0xa0(%eax),%ebx
80104612:	89 5a 18             	mov    %ebx,0x18(%edx)
80104615:	8b 98 a4 00 00 00    	mov    0xa4(%eax),%ebx
8010461b:	89 5a 1c             	mov    %ebx,0x1c(%edx)
8010461e:	8b 98 a8 00 00 00    	mov    0xa8(%eax),%ebx
80104624:	89 5a 20             	mov    %ebx,0x20(%edx)
    ps->num_run = p->numrun;
80104627:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
8010462d:	89 5a 08             	mov    %ebx,0x8(%edx)
    uproc.runtime = p->rtime;
80104630:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104636:	89 15 24 39 11 80    	mov    %edx,0x80113924
    uproc.current_queue = p->pqlvl;
8010463c:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
    uproc.num_run = p->numrun;
80104642:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
    uproc.current_queue = p->pqlvl;
80104648:	89 15 2c 39 11 80    	mov    %edx,0x8011392c
    uproc.num_run = p->numrun;
8010464e:	a3 28 39 11 80       	mov    %eax,0x80113928
    return 0;
80104653:	31 c0                	xor    %eax,%eax
}
80104655:	5b                   	pop    %ebx
80104656:	5d                   	pop    %ebp
80104657:	c3                   	ret    
80104658:	90                   	nop
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104660 <set_priority>:

// Change Process priority
int set_priority(int pid, int priority){
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 10             	sub    $0x10,%esp
80104667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock); int rp=-1;
8010466a:	68 60 39 11 80       	push   $0x80113960
8010466f:	e8 ec 02 00 00       	call   80104960 <acquire>
80104674:	83 c4 10             	add    $0x10,%esp
  int flag_break = 0;
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104677:	ba 94 39 11 80       	mov    $0x80113994,%edx
    flag_break = 1;
    if(p->pid != pid) {
8010467c:	39 5a 10             	cmp    %ebx,0x10(%edx)
8010467f:	74 1f                	je     801046a0 <set_priority+0x40>
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104681:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80104687:	81 fa 94 65 11 80    	cmp    $0x80116594,%edx
8010468d:	72 ed                	jb     8010467c <set_priority+0x1c>
8010468f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104694:	eb 19                	jmp    801046af <set_priority+0x4f>
80104696:	8d 76 00             	lea    0x0(%esi),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      flag_break = 0;
      continue;
    }
    rp=p->priority;
    p->priority = priority;
801046a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    rp=p->priority;
801046a3:	8b 9a 88 00 00 00    	mov    0x88(%edx),%ebx
    p->priority = priority;
801046a9:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
    if(flag_break){
      break;
    }
  }
  release(&ptable.lock);
801046af:	83 ec 0c             	sub    $0xc,%esp
801046b2:	68 60 39 11 80       	push   $0x80113960
801046b7:	e8 64 03 00 00       	call   80104a20 <release>
  return rp;
}
801046bc:	89 d8                	mov    %ebx,%eax
801046be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c1:	c9                   	leave  
801046c2:	c3                   	ret    
801046c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <check>:

int check(){
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 14             	sub    $0x14,%esp
  cprintf("print from here\n");
801046d6:	68 03 7d 10 80       	push   $0x80107d03
801046db:	e8 80 bf ff ff       	call   80100660 <cprintf>
  return 1;
801046e0:	b8 01 00 00 00       	mov    $0x1,%eax
801046e5:	c9                   	leave  
801046e6:	c3                   	ret    
801046e7:	66 90                	xchg   %ax,%ax
801046e9:	66 90                	xchg   %ax,%ax
801046eb:	66 90                	xchg   %ax,%ax
801046ed:	66 90                	xchg   %ax,%ax
801046ef:	90                   	nop

801046f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046fa:	68 58 7d 10 80       	push   $0x80107d58
801046ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104702:	50                   	push   %eax
80104703:	e8 18 01 00 00       	call   80104820 <initlock>
  lk->name = name;
80104708:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010470b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104711:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104714:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010471b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010471e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104721:	c9                   	leave  
80104722:	c3                   	ret    
80104723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	8d 73 04             	lea    0x4(%ebx),%esi
8010473e:	56                   	push   %esi
8010473f:	e8 1c 02 00 00       	call   80104960 <acquire>
  while (lk->locked) {
80104744:	8b 13                	mov    (%ebx),%edx
80104746:	83 c4 10             	add    $0x10,%esp
80104749:	85 d2                	test   %edx,%edx
8010474b:	74 16                	je     80104763 <acquiresleep+0x33>
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104750:	83 ec 08             	sub    $0x8,%esp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	e8 a6 f8 ff ff       	call   80104000 <sleep>
  while (lk->locked) {
8010475a:	8b 03                	mov    (%ebx),%eax
8010475c:	83 c4 10             	add    $0x10,%esp
8010475f:	85 c0                	test   %eax,%eax
80104761:	75 ed                	jne    80104750 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104763:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104769:	e8 02 f1 ff ff       	call   80103870 <myproc>
8010476e:	8b 40 10             	mov    0x10(%eax),%eax
80104771:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104774:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104777:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010477a:	5b                   	pop    %ebx
8010477b:	5e                   	pop    %esi
8010477c:	5d                   	pop    %ebp
  release(&lk->lk);
8010477d:	e9 9e 02 00 00       	jmp    80104a20 <release>
80104782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	8d 73 04             	lea    0x4(%ebx),%esi
8010479e:	56                   	push   %esi
8010479f:	e8 bc 01 00 00       	call   80104960 <acquire>
  lk->locked = 0;
801047a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047b1:	89 1c 24             	mov    %ebx,(%esp)
801047b4:	e8 47 fb ff ff       	call   80104300 <wakeup>
  release(&lk->lk);
801047b9:	89 75 08             	mov    %esi,0x8(%ebp)
801047bc:	83 c4 10             	add    $0x10,%esp
}
801047bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c2:	5b                   	pop    %ebx
801047c3:	5e                   	pop    %esi
801047c4:	5d                   	pop    %ebp
  release(&lk->lk);
801047c5:	e9 56 02 00 00       	jmp    80104a20 <release>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	53                   	push   %ebx
801047d6:	31 ff                	xor    %edi,%edi
801047d8:	83 ec 18             	sub    $0x18,%esp
801047db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047de:	8d 73 04             	lea    0x4(%ebx),%esi
801047e1:	56                   	push   %esi
801047e2:	e8 79 01 00 00       	call   80104960 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801047e7:	8b 03                	mov    (%ebx),%eax
801047e9:	83 c4 10             	add    $0x10,%esp
801047ec:	85 c0                	test   %eax,%eax
801047ee:	74 13                	je     80104803 <holdingsleep+0x33>
801047f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047f3:	e8 78 f0 ff ff       	call   80103870 <myproc>
801047f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801047fb:	0f 94 c0             	sete   %al
801047fe:	0f b6 c0             	movzbl %al,%eax
80104801:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104803:	83 ec 0c             	sub    $0xc,%esp
80104806:	56                   	push   %esi
80104807:	e8 14 02 00 00       	call   80104a20 <release>
  return r;
}
8010480c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010480f:	89 f8                	mov    %edi,%eax
80104811:	5b                   	pop    %ebx
80104812:	5e                   	pop    %esi
80104813:	5f                   	pop    %edi
80104814:	5d                   	pop    %ebp
80104815:	c3                   	ret    
80104816:	66 90                	xchg   %ax,%ax
80104818:	66 90                	xchg   %ax,%ax
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104826:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010482f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104832:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    
8010483b:	90                   	nop
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104840:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104841:	31 d2                	xor    %edx,%edx
{
80104843:	89 e5                	mov    %esp,%ebp
80104845:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104846:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010484c:	83 e8 08             	sub    $0x8,%eax
8010484f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104850:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104856:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010485c:	77 1a                	ja     80104878 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010485e:	8b 58 04             	mov    0x4(%eax),%ebx
80104861:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104864:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104867:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104869:	83 fa 0a             	cmp    $0xa,%edx
8010486c:	75 e2                	jne    80104850 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010486e:	5b                   	pop    %ebx
8010486f:	5d                   	pop    %ebp
80104870:	c3                   	ret    
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104878:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010487b:	83 c1 28             	add    $0x28,%ecx
8010487e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104886:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104889:	39 c1                	cmp    %eax,%ecx
8010488b:	75 f3                	jne    80104880 <getcallerpcs+0x40>
}
8010488d:	5b                   	pop    %ebx
8010488e:	5d                   	pop    %ebp
8010488f:	c3                   	ret    

80104890 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 04             	sub    $0x4,%esp
80104897:	9c                   	pushf  
80104898:	5b                   	pop    %ebx
  asm volatile("cli");
80104899:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010489a:	e8 41 ef ff ff       	call   801037e0 <mycpu>
8010489f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048a5:	85 c0                	test   %eax,%eax
801048a7:	75 11                	jne    801048ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048af:	e8 2c ef ff ff       	call   801037e0 <mycpu>
801048b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801048ba:	e8 21 ef ff ff       	call   801037e0 <mycpu>
801048bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048c6:	83 c4 04             	add    $0x4,%esp
801048c9:	5b                   	pop    %ebx
801048ca:	5d                   	pop    %ebp
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048d0 <popcli>:

void
popcli(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048d6:	9c                   	pushf  
801048d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048d8:	f6 c4 02             	test   $0x2,%ah
801048db:	75 35                	jne    80104912 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048dd:	e8 fe ee ff ff       	call   801037e0 <mycpu>
801048e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801048e9:	78 34                	js     8010491f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048eb:	e8 f0 ee ff ff       	call   801037e0 <mycpu>
801048f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048f6:	85 d2                	test   %edx,%edx
801048f8:	74 06                	je     80104900 <popcli+0x30>
    sti();
}
801048fa:	c9                   	leave  
801048fb:	c3                   	ret    
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104900:	e8 db ee ff ff       	call   801037e0 <mycpu>
80104905:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010490b:	85 c0                	test   %eax,%eax
8010490d:	74 eb                	je     801048fa <popcli+0x2a>
  asm volatile("sti");
8010490f:	fb                   	sti    
}
80104910:	c9                   	leave  
80104911:	c3                   	ret    
    panic("popcli - interruptible");
80104912:	83 ec 0c             	sub    $0xc,%esp
80104915:	68 63 7d 10 80       	push   $0x80107d63
8010491a:	e8 71 ba ff ff       	call   80100390 <panic>
    panic("popcli");
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	68 7a 7d 10 80       	push   $0x80107d7a
80104927:	e8 64 ba ff ff       	call   80100390 <panic>
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104930 <holding>:
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
80104935:	8b 75 08             	mov    0x8(%ebp),%esi
80104938:	31 db                	xor    %ebx,%ebx
  pushcli();
8010493a:	e8 51 ff ff ff       	call   80104890 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010493f:	8b 06                	mov    (%esi),%eax
80104941:	85 c0                	test   %eax,%eax
80104943:	74 10                	je     80104955 <holding+0x25>
80104945:	8b 5e 08             	mov    0x8(%esi),%ebx
80104948:	e8 93 ee ff ff       	call   801037e0 <mycpu>
8010494d:	39 c3                	cmp    %eax,%ebx
8010494f:	0f 94 c3             	sete   %bl
80104952:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104955:	e8 76 ff ff ff       	call   801048d0 <popcli>
}
8010495a:	89 d8                	mov    %ebx,%eax
8010495c:	5b                   	pop    %ebx
8010495d:	5e                   	pop    %esi
8010495e:	5d                   	pop    %ebp
8010495f:	c3                   	ret    

80104960 <acquire>:
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104965:	e8 26 ff ff ff       	call   80104890 <pushcli>
  if(holding(lk))
8010496a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010496d:	83 ec 0c             	sub    $0xc,%esp
80104970:	53                   	push   %ebx
80104971:	e8 ba ff ff ff       	call   80104930 <holding>
80104976:	83 c4 10             	add    $0x10,%esp
80104979:	85 c0                	test   %eax,%eax
8010497b:	0f 85 83 00 00 00    	jne    80104a04 <acquire+0xa4>
80104981:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104983:	ba 01 00 00 00       	mov    $0x1,%edx
80104988:	eb 09                	jmp    80104993 <acquire+0x33>
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104990:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104993:	89 d0                	mov    %edx,%eax
80104995:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104998:	85 c0                	test   %eax,%eax
8010499a:	75 f4                	jne    80104990 <acquire+0x30>
  __sync_synchronize();
8010499c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801049a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049a4:	e8 37 ee ff ff       	call   801037e0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801049a9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801049ac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801049af:	89 e8                	mov    %ebp,%eax
801049b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049b8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801049be:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801049c4:	77 1a                	ja     801049e0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801049c6:	8b 48 04             	mov    0x4(%eax),%ecx
801049c9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801049cc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801049cf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049d1:	83 fe 0a             	cmp    $0xa,%esi
801049d4:	75 e2                	jne    801049b8 <acquire+0x58>
}
801049d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d9:	5b                   	pop    %ebx
801049da:	5e                   	pop    %esi
801049db:	5d                   	pop    %ebp
801049dc:	c3                   	ret    
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
801049e0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801049e3:	83 c2 28             	add    $0x28,%edx
801049e6:	8d 76 00             	lea    0x0(%esi),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801049f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049f9:	39 d0                	cmp    %edx,%eax
801049fb:	75 f3                	jne    801049f0 <acquire+0x90>
}
801049fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a00:	5b                   	pop    %ebx
80104a01:	5e                   	pop    %esi
80104a02:	5d                   	pop    %ebp
80104a03:	c3                   	ret    
    panic("acquire");
80104a04:	83 ec 0c             	sub    $0xc,%esp
80104a07:	68 81 7d 10 80       	push   $0x80107d81
80104a0c:	e8 7f b9 ff ff       	call   80100390 <panic>
80104a11:	eb 0d                	jmp    80104a20 <release>
80104a13:	90                   	nop
80104a14:	90                   	nop
80104a15:	90                   	nop
80104a16:	90                   	nop
80104a17:	90                   	nop
80104a18:	90                   	nop
80104a19:	90                   	nop
80104a1a:	90                   	nop
80104a1b:	90                   	nop
80104a1c:	90                   	nop
80104a1d:	90                   	nop
80104a1e:	90                   	nop
80104a1f:	90                   	nop

80104a20 <release>:
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 10             	sub    $0x10,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a2a:	53                   	push   %ebx
80104a2b:	e8 00 ff ff ff       	call   80104930 <holding>
80104a30:	83 c4 10             	add    $0x10,%esp
80104a33:	85 c0                	test   %eax,%eax
80104a35:	74 22                	je     80104a59 <release+0x39>
  lk->pcs[0] = 0;
80104a37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a45:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a53:	c9                   	leave  
  popcli();
80104a54:	e9 77 fe ff ff       	jmp    801048d0 <popcli>
    panic("release");
80104a59:	83 ec 0c             	sub    $0xc,%esp
80104a5c:	68 89 7d 10 80       	push   $0x80107d89
80104a61:	e8 2a b9 ff ff       	call   80100390 <panic>
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	53                   	push   %ebx
80104a75:	8b 55 08             	mov    0x8(%ebp),%edx
80104a78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a7b:	f6 c2 03             	test   $0x3,%dl
80104a7e:	75 05                	jne    80104a85 <memset+0x15>
80104a80:	f6 c1 03             	test   $0x3,%cl
80104a83:	74 13                	je     80104a98 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104a85:	89 d7                	mov    %edx,%edi
80104a87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8a:	fc                   	cld    
80104a8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a8d:	5b                   	pop    %ebx
80104a8e:	89 d0                	mov    %edx,%eax
80104a90:	5f                   	pop    %edi
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
80104a93:	90                   	nop
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a9c:	c1 e9 02             	shr    $0x2,%ecx
80104a9f:	89 f8                	mov    %edi,%eax
80104aa1:	89 fb                	mov    %edi,%ebx
80104aa3:	c1 e0 18             	shl    $0x18,%eax
80104aa6:	c1 e3 10             	shl    $0x10,%ebx
80104aa9:	09 d8                	or     %ebx,%eax
80104aab:	09 f8                	or     %edi,%eax
80104aad:	c1 e7 08             	shl    $0x8,%edi
80104ab0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ab2:	89 d7                	mov    %edx,%edi
80104ab4:	fc                   	cld    
80104ab5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ab7:	5b                   	pop    %ebx
80104ab8:	89 d0                	mov    %edx,%eax
80104aba:	5f                   	pop    %edi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi

80104ac0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ac9:	8b 75 08             	mov    0x8(%ebp),%esi
80104acc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104acf:	85 db                	test   %ebx,%ebx
80104ad1:	74 29                	je     80104afc <memcmp+0x3c>
    if(*s1 != *s2)
80104ad3:	0f b6 16             	movzbl (%esi),%edx
80104ad6:	0f b6 0f             	movzbl (%edi),%ecx
80104ad9:	38 d1                	cmp    %dl,%cl
80104adb:	75 2b                	jne    80104b08 <memcmp+0x48>
80104add:	b8 01 00 00 00       	mov    $0x1,%eax
80104ae2:	eb 14                	jmp    80104af8 <memcmp+0x38>
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104aec:	83 c0 01             	add    $0x1,%eax
80104aef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104af4:	38 ca                	cmp    %cl,%dl
80104af6:	75 10                	jne    80104b08 <memcmp+0x48>
  while(n-- > 0){
80104af8:	39 d8                	cmp    %ebx,%eax
80104afa:	75 ec                	jne    80104ae8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104afc:	5b                   	pop    %ebx
  return 0;
80104afd:	31 c0                	xor    %eax,%eax
}
80104aff:	5e                   	pop    %esi
80104b00:	5f                   	pop    %edi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	90                   	nop
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b08:	0f b6 c2             	movzbl %dl,%eax
}
80104b0b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b0c:	29 c8                	sub    %ecx,%eax
}
80104b0e:	5e                   	pop    %esi
80104b0f:	5f                   	pop    %edi
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret    
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 45 08             	mov    0x8(%ebp),%eax
80104b28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b2b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b2e:	39 c3                	cmp    %eax,%ebx
80104b30:	73 26                	jae    80104b58 <memmove+0x38>
80104b32:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b35:	39 c8                	cmp    %ecx,%eax
80104b37:	73 1f                	jae    80104b58 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b39:	85 f6                	test   %esi,%esi
80104b3b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b3e:	74 0f                	je     80104b4f <memmove+0x2f>
      *--d = *--s;
80104b40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b47:	83 ea 01             	sub    $0x1,%edx
80104b4a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b4d:	75 f1                	jne    80104b40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b4f:	5b                   	pop    %ebx
80104b50:	5e                   	pop    %esi
80104b51:	5d                   	pop    %ebp
80104b52:	c3                   	ret    
80104b53:	90                   	nop
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b58:	31 d2                	xor    %edx,%edx
80104b5a:	85 f6                	test   %esi,%esi
80104b5c:	74 f1                	je     80104b4f <memmove+0x2f>
80104b5e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b67:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b6a:	39 d6                	cmp    %edx,%esi
80104b6c:	75 f2                	jne    80104b60 <memmove+0x40>
}
80104b6e:	5b                   	pop    %ebx
80104b6f:	5e                   	pop    %esi
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret    
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b83:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104b84:	eb 9a                	jmp    80104b20 <memmove>
80104b86:	8d 76 00             	lea    0x0(%esi),%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b90 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b98:	53                   	push   %ebx
80104b99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b9f:	85 ff                	test   %edi,%edi
80104ba1:	74 2f                	je     80104bd2 <strncmp+0x42>
80104ba3:	0f b6 01             	movzbl (%ecx),%eax
80104ba6:	0f b6 1e             	movzbl (%esi),%ebx
80104ba9:	84 c0                	test   %al,%al
80104bab:	74 37                	je     80104be4 <strncmp+0x54>
80104bad:	38 c3                	cmp    %al,%bl
80104baf:	75 33                	jne    80104be4 <strncmp+0x54>
80104bb1:	01 f7                	add    %esi,%edi
80104bb3:	eb 13                	jmp    80104bc8 <strncmp+0x38>
80104bb5:	8d 76 00             	lea    0x0(%esi),%esi
80104bb8:	0f b6 01             	movzbl (%ecx),%eax
80104bbb:	84 c0                	test   %al,%al
80104bbd:	74 21                	je     80104be0 <strncmp+0x50>
80104bbf:	0f b6 1a             	movzbl (%edx),%ebx
80104bc2:	89 d6                	mov    %edx,%esi
80104bc4:	38 d8                	cmp    %bl,%al
80104bc6:	75 1c                	jne    80104be4 <strncmp+0x54>
    n--, p++, q++;
80104bc8:	8d 56 01             	lea    0x1(%esi),%edx
80104bcb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104bce:	39 fa                	cmp    %edi,%edx
80104bd0:	75 e6                	jne    80104bb8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104bd2:	5b                   	pop    %ebx
    return 0;
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	5e                   	pop    %esi
80104bd6:	5f                   	pop    %edi
80104bd7:	5d                   	pop    %ebp
80104bd8:	c3                   	ret    
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104be4:	29 d8                	sub    %ebx,%eax
}
80104be6:	5b                   	pop    %ebx
80104be7:	5e                   	pop    %esi
80104be8:	5f                   	pop    %edi
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret    
80104beb:	90                   	nop
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bfe:	89 c2                	mov    %eax,%edx
80104c00:	eb 19                	jmp    80104c1b <strncpy+0x2b>
80104c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c08:	83 c3 01             	add    $0x1,%ebx
80104c0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c0f:	83 c2 01             	add    $0x1,%edx
80104c12:	84 c9                	test   %cl,%cl
80104c14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c17:	74 09                	je     80104c22 <strncpy+0x32>
80104c19:	89 f1                	mov    %esi,%ecx
80104c1b:	85 c9                	test   %ecx,%ecx
80104c1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c20:	7f e6                	jg     80104c08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c22:	31 c9                	xor    %ecx,%ecx
80104c24:	85 f6                	test   %esi,%esi
80104c26:	7e 17                	jle    80104c3f <strncpy+0x4f>
80104c28:	90                   	nop
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c34:	89 f3                	mov    %esi,%ebx
80104c36:	83 c1 01             	add    $0x1,%ecx
80104c39:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c3b:	85 db                	test   %ebx,%ebx
80104c3d:	7f f1                	jg     80104c30 <strncpy+0x40>
  return os;
}
80104c3f:	5b                   	pop    %ebx
80104c40:	5e                   	pop    %esi
80104c41:	5d                   	pop    %ebp
80104c42:	c3                   	ret    
80104c43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c58:	8b 45 08             	mov    0x8(%ebp),%eax
80104c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c5e:	85 c9                	test   %ecx,%ecx
80104c60:	7e 26                	jle    80104c88 <safestrcpy+0x38>
80104c62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c66:	89 c1                	mov    %eax,%ecx
80104c68:	eb 17                	jmp    80104c81 <safestrcpy+0x31>
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c70:	83 c2 01             	add    $0x1,%edx
80104c73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c77:	83 c1 01             	add    $0x1,%ecx
80104c7a:	84 db                	test   %bl,%bl
80104c7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c7f:	74 04                	je     80104c85 <safestrcpy+0x35>
80104c81:	39 f2                	cmp    %esi,%edx
80104c83:	75 eb                	jne    80104c70 <safestrcpy+0x20>
    ;
  *s = 0;
80104c85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c88:	5b                   	pop    %ebx
80104c89:	5e                   	pop    %esi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <strlen>:

int
strlen(const char *s)
{
80104c90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c91:	31 c0                	xor    %eax,%eax
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c98:	80 3a 00             	cmpb   $0x0,(%edx)
80104c9b:	74 0c                	je     80104ca9 <strlen+0x19>
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ca0:	83 c0 01             	add    $0x1,%eax
80104ca3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ca7:	75 f7                	jne    80104ca0 <strlen+0x10>
    ;
  return n;
}
80104ca9:	5d                   	pop    %ebp
80104caa:	c3                   	ret    

80104cab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104cab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104caf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104cb3:	55                   	push   %ebp
  pushl %ebx
80104cb4:	53                   	push   %ebx
  pushl %esi
80104cb5:	56                   	push   %esi
  pushl %edi
80104cb6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104cb7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104cb9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104cbb:	5f                   	pop    %edi
  popl %esi
80104cbc:	5e                   	pop    %esi
  popl %ebx
80104cbd:	5b                   	pop    %ebx
  popl %ebp
80104cbe:	5d                   	pop    %ebp
  ret
80104cbf:	c3                   	ret    

80104cc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 04             	sub    $0x4,%esp
80104cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104cca:	e8 a1 eb ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ccf:	8b 00                	mov    (%eax),%eax
80104cd1:	39 d8                	cmp    %ebx,%eax
80104cd3:	76 1b                	jbe    80104cf0 <fetchint+0x30>
80104cd5:	8d 53 04             	lea    0x4(%ebx),%edx
80104cd8:	39 d0                	cmp    %edx,%eax
80104cda:	72 14                	jb     80104cf0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cdf:	8b 13                	mov    (%ebx),%edx
80104ce1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ce3:	31 c0                	xor    %eax,%eax
}
80104ce5:	83 c4 04             	add    $0x4,%esp
80104ce8:	5b                   	pop    %ebx
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	90                   	nop
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf5:	eb ee                	jmp    80104ce5 <fetchint+0x25>
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 04             	sub    $0x4,%esp
80104d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d0a:	e8 61 eb ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz)
80104d0f:	39 18                	cmp    %ebx,(%eax)
80104d11:	76 29                	jbe    80104d3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d16:	89 da                	mov    %ebx,%edx
80104d18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d1c:	39 c3                	cmp    %eax,%ebx
80104d1e:	73 1c                	jae    80104d3c <fetchstr+0x3c>
    if(*s == 0)
80104d20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d23:	75 10                	jne    80104d35 <fetchstr+0x35>
80104d25:	eb 39                	jmp    80104d60 <fetchstr+0x60>
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d30:	80 3a 00             	cmpb   $0x0,(%edx)
80104d33:	74 1b                	je     80104d50 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d35:	83 c2 01             	add    $0x1,%edx
80104d38:	39 d0                	cmp    %edx,%eax
80104d3a:	77 f4                	ja     80104d30 <fetchstr+0x30>
    return -1;
80104d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d41:	83 c4 04             	add    $0x4,%esp
80104d44:	5b                   	pop    %ebx
80104d45:	5d                   	pop    %ebp
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d50:	83 c4 04             	add    $0x4,%esp
80104d53:	89 d0                	mov    %edx,%eax
80104d55:	29 d8                	sub    %ebx,%eax
80104d57:	5b                   	pop    %ebx
80104d58:	5d                   	pop    %ebp
80104d59:	c3                   	ret    
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104d60:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104d62:	eb dd                	jmp    80104d41 <fetchstr+0x41>
80104d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d75:	e8 f6 ea ff ff       	call   80103870 <myproc>
80104d7a:	8b 40 18             	mov    0x18(%eax),%eax
80104d7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d80:	8b 40 44             	mov    0x44(%eax),%eax
80104d83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d86:	e8 e5 ea ff ff       	call   80103870 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d8b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d8d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d90:	39 c6                	cmp    %eax,%esi
80104d92:	73 1c                	jae    80104db0 <argint+0x40>
80104d94:	8d 53 08             	lea    0x8(%ebx),%edx
80104d97:	39 d0                	cmp    %edx,%eax
80104d99:	72 15                	jb     80104db0 <argint+0x40>
  *ip = *(int*)(addr);
80104d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104da1:	89 10                	mov    %edx,(%eax)
  return 0;
80104da3:	31 c0                	xor    %eax,%eax
}
80104da5:	5b                   	pop    %ebx
80104da6:	5e                   	pop    %esi
80104da7:	5d                   	pop    %ebp
80104da8:	c3                   	ret    
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104db5:	eb ee                	jmp    80104da5 <argint+0x35>
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
80104dc5:	83 ec 10             	sub    $0x10,%esp
80104dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104dcb:	e8 a0 ea ff ff       	call   80103870 <myproc>
80104dd0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd5:	83 ec 08             	sub    $0x8,%esp
80104dd8:	50                   	push   %eax
80104dd9:	ff 75 08             	pushl  0x8(%ebp)
80104ddc:	e8 8f ff ff ff       	call   80104d70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104de1:	83 c4 10             	add    $0x10,%esp
80104de4:	85 c0                	test   %eax,%eax
80104de6:	78 28                	js     80104e10 <argptr+0x50>
80104de8:	85 db                	test   %ebx,%ebx
80104dea:	78 24                	js     80104e10 <argptr+0x50>
80104dec:	8b 16                	mov    (%esi),%edx
80104dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df1:	39 c2                	cmp    %eax,%edx
80104df3:	76 1b                	jbe    80104e10 <argptr+0x50>
80104df5:	01 c3                	add    %eax,%ebx
80104df7:	39 da                	cmp    %ebx,%edx
80104df9:	72 15                	jb     80104e10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dfe:	89 02                	mov    %eax,(%edx)
  return 0;
80104e00:	31 c0                	xor    %eax,%eax
}
80104e02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e05:	5b                   	pop    %ebx
80104e06:	5e                   	pop    %esi
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e15:	eb eb                	jmp    80104e02 <argptr+0x42>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e29:	50                   	push   %eax
80104e2a:	ff 75 08             	pushl  0x8(%ebp)
80104e2d:	e8 3e ff ff ff       	call   80104d70 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 17                	js     80104e50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e39:	83 ec 08             	sub    $0x8,%esp
80104e3c:	ff 75 0c             	pushl  0xc(%ebp)
80104e3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e42:	e8 b9 fe ff ff       	call   80104d00 <fetchstr>
80104e47:	83 c4 10             	add    $0x10,%esp
}
80104e4a:	c9                   	leave  
80104e4b:	c3                   	ret    
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <syscall>:
[SYS_getticks] sys_getticks,
};

void
syscall(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	53                   	push   %ebx
80104e64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e67:	e8 04 ea ff ff       	call   80103870 <myproc>
80104e6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e6e:	8b 40 18             	mov    0x18(%eax),%eax
80104e71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e77:	83 fa 18             	cmp    $0x18,%edx
80104e7a:	77 1c                	ja     80104e98 <syscall+0x38>
80104e7c:	8b 14 85 c0 7d 10 80 	mov    -0x7fef8240(,%eax,4),%edx
80104e83:	85 d2                	test   %edx,%edx
80104e85:	74 11                	je     80104e98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104e87:	ff d2                	call   *%edx
80104e89:	8b 53 18             	mov    0x18(%ebx),%edx
80104e8c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e92:	c9                   	leave  
80104e93:	c3                   	ret    
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e99:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e9c:	50                   	push   %eax
80104e9d:	ff 73 10             	pushl  0x10(%ebx)
80104ea0:	68 91 7d 10 80       	push   $0x80107d91
80104ea5:	e8 b6 b7 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104eaa:	8b 43 18             	mov    0x18(%ebx),%eax
80104ead:	83 c4 10             	add    $0x10,%esp
80104eb0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eba:	c9                   	leave  
80104ebb:	c3                   	ret    
80104ebc:	66 90                	xchg   %ax,%ax
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ec6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104ec9:	83 ec 34             	sub    $0x34,%esp
80104ecc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ecf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ed2:	56                   	push   %esi
80104ed3:	50                   	push   %eax
{
80104ed4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ed7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104eda:	e8 21 d0 ff ff       	call   80101f00 <nameiparent>
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	85 c0                	test   %eax,%eax
80104ee4:	0f 84 46 01 00 00    	je     80105030 <create+0x170>
    return 0;
  ilock(dp);
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	89 c3                	mov    %eax,%ebx
80104eef:	50                   	push   %eax
80104ef0:	e8 8b c7 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ef5:	83 c4 0c             	add    $0xc,%esp
80104ef8:	6a 00                	push   $0x0
80104efa:	56                   	push   %esi
80104efb:	53                   	push   %ebx
80104efc:	e8 af cc ff ff       	call   80101bb0 <dirlookup>
80104f01:	83 c4 10             	add    $0x10,%esp
80104f04:	85 c0                	test   %eax,%eax
80104f06:	89 c7                	mov    %eax,%edi
80104f08:	74 36                	je     80104f40 <create+0x80>
    iunlockput(dp);
80104f0a:	83 ec 0c             	sub    $0xc,%esp
80104f0d:	53                   	push   %ebx
80104f0e:	e8 fd c9 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104f13:	89 3c 24             	mov    %edi,(%esp)
80104f16:	e8 65 c7 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f1b:	83 c4 10             	add    $0x10,%esp
80104f1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f23:	0f 85 97 00 00 00    	jne    80104fc0 <create+0x100>
80104f29:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f2e:	0f 85 8c 00 00 00    	jne    80104fc0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f37:	89 f8                	mov    %edi,%eax
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5f                   	pop    %edi
80104f3c:	5d                   	pop    %ebp
80104f3d:	c3                   	ret    
80104f3e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104f40:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f44:	83 ec 08             	sub    $0x8,%esp
80104f47:	50                   	push   %eax
80104f48:	ff 33                	pushl  (%ebx)
80104f4a:	e8 c1 c5 ff ff       	call   80101510 <ialloc>
80104f4f:	83 c4 10             	add    $0x10,%esp
80104f52:	85 c0                	test   %eax,%eax
80104f54:	89 c7                	mov    %eax,%edi
80104f56:	0f 84 e8 00 00 00    	je     80105044 <create+0x184>
  ilock(ip);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	50                   	push   %eax
80104f60:	e8 1b c7 ff ff       	call   80101680 <ilock>
  ip->major = major;
80104f65:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f69:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104f6d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f71:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104f75:	b8 01 00 00 00       	mov    $0x1,%eax
80104f7a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104f7e:	89 3c 24             	mov    %edi,(%esp)
80104f81:	e8 4a c6 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f8e:	74 50                	je     80104fe0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f90:	83 ec 04             	sub    $0x4,%esp
80104f93:	ff 77 04             	pushl  0x4(%edi)
80104f96:	56                   	push   %esi
80104f97:	53                   	push   %ebx
80104f98:	e8 83 ce ff ff       	call   80101e20 <dirlink>
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	0f 88 8f 00 00 00    	js     80105037 <create+0x177>
  iunlockput(dp);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	53                   	push   %ebx
80104fac:	e8 5f c9 ff ff       	call   80101910 <iunlockput>
  return ip;
80104fb1:	83 c4 10             	add    $0x10,%esp
}
80104fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fb7:	89 f8                	mov    %edi,%eax
80104fb9:	5b                   	pop    %ebx
80104fba:	5e                   	pop    %esi
80104fbb:	5f                   	pop    %edi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	57                   	push   %edi
    return 0;
80104fc4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104fc6:	e8 45 c9 ff ff       	call   80101910 <iunlockput>
    return 0;
80104fcb:	83 c4 10             	add    $0x10,%esp
}
80104fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd1:	89 f8                	mov    %edi,%eax
80104fd3:	5b                   	pop    %ebx
80104fd4:	5e                   	pop    %esi
80104fd5:	5f                   	pop    %edi
80104fd6:	5d                   	pop    %ebp
80104fd7:	c3                   	ret    
80104fd8:	90                   	nop
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104fe0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	53                   	push   %ebx
80104fe9:	e8 e2 c5 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fee:	83 c4 0c             	add    $0xc,%esp
80104ff1:	ff 77 04             	pushl  0x4(%edi)
80104ff4:	68 44 7e 10 80       	push   $0x80107e44
80104ff9:	57                   	push   %edi
80104ffa:	e8 21 ce ff ff       	call   80101e20 <dirlink>
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	85 c0                	test   %eax,%eax
80105004:	78 1c                	js     80105022 <create+0x162>
80105006:	83 ec 04             	sub    $0x4,%esp
80105009:	ff 73 04             	pushl  0x4(%ebx)
8010500c:	68 43 7e 10 80       	push   $0x80107e43
80105011:	57                   	push   %edi
80105012:	e8 09 ce ff ff       	call   80101e20 <dirlink>
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	85 c0                	test   %eax,%eax
8010501c:	0f 89 6e ff ff ff    	jns    80104f90 <create+0xd0>
      panic("create dots");
80105022:	83 ec 0c             	sub    $0xc,%esp
80105025:	68 37 7e 10 80       	push   $0x80107e37
8010502a:	e8 61 b3 ff ff       	call   80100390 <panic>
8010502f:	90                   	nop
    return 0;
80105030:	31 ff                	xor    %edi,%edi
80105032:	e9 fd fe ff ff       	jmp    80104f34 <create+0x74>
    panic("create: dirlink");
80105037:	83 ec 0c             	sub    $0xc,%esp
8010503a:	68 46 7e 10 80       	push   $0x80107e46
8010503f:	e8 4c b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	68 28 7e 10 80       	push   $0x80107e28
8010504c:	e8 3f b3 ff ff       	call   80100390 <panic>
80105051:	eb 0d                	jmp    80105060 <argfd.constprop.0>
80105053:	90                   	nop
80105054:	90                   	nop
80105055:	90                   	nop
80105056:	90                   	nop
80105057:	90                   	nop
80105058:	90                   	nop
80105059:	90                   	nop
8010505a:	90                   	nop
8010505b:	90                   	nop
8010505c:	90                   	nop
8010505d:	90                   	nop
8010505e:	90                   	nop
8010505f:	90                   	nop

80105060 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
80105065:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105067:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010506a:	89 d6                	mov    %edx,%esi
8010506c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506f:	50                   	push   %eax
80105070:	6a 00                	push   $0x0
80105072:	e8 f9 fc ff ff       	call   80104d70 <argint>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	85 c0                	test   %eax,%eax
8010507c:	78 2a                	js     801050a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105082:	77 24                	ja     801050a8 <argfd.constprop.0+0x48>
80105084:	e8 e7 e7 ff ff       	call   80103870 <myproc>
80105089:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010508c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105090:	85 c0                	test   %eax,%eax
80105092:	74 14                	je     801050a8 <argfd.constprop.0+0x48>
  if(pfd)
80105094:	85 db                	test   %ebx,%ebx
80105096:	74 02                	je     8010509a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105098:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010509a:	89 06                	mov    %eax,(%esi)
  return 0;
8010509c:	31 c0                	xor    %eax,%eax
}
8010509e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a1:	5b                   	pop    %ebx
801050a2:	5e                   	pop    %esi
801050a3:	5d                   	pop    %ebp
801050a4:	c3                   	ret    
801050a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ad:	eb ef                	jmp    8010509e <argfd.constprop.0+0x3e>
801050af:	90                   	nop

801050b0 <sys_dup>:
{
801050b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801050b1:	31 c0                	xor    %eax,%eax
{
801050b3:	89 e5                	mov    %esp,%ebp
801050b5:	56                   	push   %esi
801050b6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801050b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801050ba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050bd:	e8 9e ff ff ff       	call   80105060 <argfd.constprop.0>
801050c2:	85 c0                	test   %eax,%eax
801050c4:	78 42                	js     80105108 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801050c6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050c9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801050cb:	e8 a0 e7 ff ff       	call   80103870 <myproc>
801050d0:	eb 0e                	jmp    801050e0 <sys_dup+0x30>
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050d8:	83 c3 01             	add    $0x1,%ebx
801050db:	83 fb 10             	cmp    $0x10,%ebx
801050de:	74 28                	je     80105108 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801050e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050e4:	85 d2                	test   %edx,%edx
801050e6:	75 f0                	jne    801050d8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801050e8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801050ec:	83 ec 0c             	sub    $0xc,%esp
801050ef:	ff 75 f4             	pushl  -0xc(%ebp)
801050f2:	e8 f9 bc ff ff       	call   80100df0 <filedup>
  return fd;
801050f7:	83 c4 10             	add    $0x10,%esp
}
801050fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050fd:	89 d8                	mov    %ebx,%eax
801050ff:	5b                   	pop    %ebx
80105100:	5e                   	pop    %esi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	90                   	nop
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105108:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010510b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105110:	89 d8                	mov    %ebx,%eax
80105112:	5b                   	pop    %ebx
80105113:	5e                   	pop    %esi
80105114:	5d                   	pop    %ebp
80105115:	c3                   	ret    
80105116:	8d 76 00             	lea    0x0(%esi),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_read>:
{
80105120:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105121:	31 c0                	xor    %eax,%eax
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105128:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010512b:	e8 30 ff ff ff       	call   80105060 <argfd.constprop.0>
80105130:	85 c0                	test   %eax,%eax
80105132:	78 4c                	js     80105180 <sys_read+0x60>
80105134:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105137:	83 ec 08             	sub    $0x8,%esp
8010513a:	50                   	push   %eax
8010513b:	6a 02                	push   $0x2
8010513d:	e8 2e fc ff ff       	call   80104d70 <argint>
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	85 c0                	test   %eax,%eax
80105147:	78 37                	js     80105180 <sys_read+0x60>
80105149:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010514c:	83 ec 04             	sub    $0x4,%esp
8010514f:	ff 75 f0             	pushl  -0x10(%ebp)
80105152:	50                   	push   %eax
80105153:	6a 01                	push   $0x1
80105155:	e8 66 fc ff ff       	call   80104dc0 <argptr>
8010515a:	83 c4 10             	add    $0x10,%esp
8010515d:	85 c0                	test   %eax,%eax
8010515f:	78 1f                	js     80105180 <sys_read+0x60>
  return fileread(f, p, n);
80105161:	83 ec 04             	sub    $0x4,%esp
80105164:	ff 75 f0             	pushl  -0x10(%ebp)
80105167:	ff 75 f4             	pushl  -0xc(%ebp)
8010516a:	ff 75 ec             	pushl  -0x14(%ebp)
8010516d:	e8 ee bd ff ff       	call   80100f60 <fileread>
80105172:	83 c4 10             	add    $0x10,%esp
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105185:	c9                   	leave  
80105186:	c3                   	ret    
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <sys_write>:
{
80105190:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105191:	31 c0                	xor    %eax,%eax
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105198:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010519b:	e8 c0 fe ff ff       	call   80105060 <argfd.constprop.0>
801051a0:	85 c0                	test   %eax,%eax
801051a2:	78 4c                	js     801051f0 <sys_write+0x60>
801051a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a7:	83 ec 08             	sub    $0x8,%esp
801051aa:	50                   	push   %eax
801051ab:	6a 02                	push   $0x2
801051ad:	e8 be fb ff ff       	call   80104d70 <argint>
801051b2:	83 c4 10             	add    $0x10,%esp
801051b5:	85 c0                	test   %eax,%eax
801051b7:	78 37                	js     801051f0 <sys_write+0x60>
801051b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051bc:	83 ec 04             	sub    $0x4,%esp
801051bf:	ff 75 f0             	pushl  -0x10(%ebp)
801051c2:	50                   	push   %eax
801051c3:	6a 01                	push   $0x1
801051c5:	e8 f6 fb ff ff       	call   80104dc0 <argptr>
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	85 c0                	test   %eax,%eax
801051cf:	78 1f                	js     801051f0 <sys_write+0x60>
  return filewrite(f, p, n);
801051d1:	83 ec 04             	sub    $0x4,%esp
801051d4:	ff 75 f0             	pushl  -0x10(%ebp)
801051d7:	ff 75 f4             	pushl  -0xc(%ebp)
801051da:	ff 75 ec             	pushl  -0x14(%ebp)
801051dd:	e8 0e be ff ff       	call   80100ff0 <filewrite>
801051e2:	83 c4 10             	add    $0x10,%esp
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_close>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105206:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105209:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010520c:	e8 4f fe ff ff       	call   80105060 <argfd.constprop.0>
80105211:	85 c0                	test   %eax,%eax
80105213:	78 2b                	js     80105240 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105215:	e8 56 e6 ff ff       	call   80103870 <myproc>
8010521a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010521d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105220:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105227:	00 
  fileclose(f);
80105228:	ff 75 f4             	pushl  -0xc(%ebp)
8010522b:	e8 10 bc ff ff       	call   80100e40 <fileclose>
  return 0;
80105230:	83 c4 10             	add    $0x10,%esp
80105233:	31 c0                	xor    %eax,%eax
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_fstat>:
{
80105250:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105251:	31 c0                	xor    %eax,%eax
{
80105253:	89 e5                	mov    %esp,%ebp
80105255:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105258:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010525b:	e8 00 fe ff ff       	call   80105060 <argfd.constprop.0>
80105260:	85 c0                	test   %eax,%eax
80105262:	78 2c                	js     80105290 <sys_fstat+0x40>
80105264:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105267:	83 ec 04             	sub    $0x4,%esp
8010526a:	6a 14                	push   $0x14
8010526c:	50                   	push   %eax
8010526d:	6a 01                	push   $0x1
8010526f:	e8 4c fb ff ff       	call   80104dc0 <argptr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	78 15                	js     80105290 <sys_fstat+0x40>
  return filestat(f, st);
8010527b:	83 ec 08             	sub    $0x8,%esp
8010527e:	ff 75 f4             	pushl  -0xc(%ebp)
80105281:	ff 75 f0             	pushl  -0x10(%ebp)
80105284:	e8 87 bc ff ff       	call   80100f10 <filestat>
80105289:	83 c4 10             	add    $0x10,%esp
}
8010528c:	c9                   	leave  
8010528d:	c3                   	ret    
8010528e:	66 90                	xchg   %ax,%ax
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052a0 <sys_link>:
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	56                   	push   %esi
801052a5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052ac:	50                   	push   %eax
801052ad:	6a 00                	push   $0x0
801052af:	e8 6c fb ff ff       	call   80104e20 <argstr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	0f 88 fb 00 00 00    	js     801053ba <sys_link+0x11a>
801052bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052c2:	83 ec 08             	sub    $0x8,%esp
801052c5:	50                   	push   %eax
801052c6:	6a 01                	push   $0x1
801052c8:	e8 53 fb ff ff       	call   80104e20 <argstr>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	0f 88 e2 00 00 00    	js     801053ba <sys_link+0x11a>
  begin_op();
801052d8:	e8 c3 d8 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
801052dd:	83 ec 0c             	sub    $0xc,%esp
801052e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801052e3:	e8 f8 cb ff ff       	call   80101ee0 <namei>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	85 c0                	test   %eax,%eax
801052ed:	89 c3                	mov    %eax,%ebx
801052ef:	0f 84 ea 00 00 00    	je     801053df <sys_link+0x13f>
  ilock(ip);
801052f5:	83 ec 0c             	sub    $0xc,%esp
801052f8:	50                   	push   %eax
801052f9:	e8 82 c3 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105306:	0f 84 bb 00 00 00    	je     801053c7 <sys_link+0x127>
  ip->nlink++;
8010530c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105311:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105314:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105317:	53                   	push   %ebx
80105318:	e8 b3 c2 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010531d:	89 1c 24             	mov    %ebx,(%esp)
80105320:	e8 3b c4 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105325:	58                   	pop    %eax
80105326:	5a                   	pop    %edx
80105327:	57                   	push   %edi
80105328:	ff 75 d0             	pushl  -0x30(%ebp)
8010532b:	e8 d0 cb ff ff       	call   80101f00 <nameiparent>
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	85 c0                	test   %eax,%eax
80105335:	89 c6                	mov    %eax,%esi
80105337:	74 5b                	je     80105394 <sys_link+0xf4>
  ilock(dp);
80105339:	83 ec 0c             	sub    $0xc,%esp
8010533c:	50                   	push   %eax
8010533d:	e8 3e c3 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	8b 03                	mov    (%ebx),%eax
80105347:	39 06                	cmp    %eax,(%esi)
80105349:	75 3d                	jne    80105388 <sys_link+0xe8>
8010534b:	83 ec 04             	sub    $0x4,%esp
8010534e:	ff 73 04             	pushl  0x4(%ebx)
80105351:	57                   	push   %edi
80105352:	56                   	push   %esi
80105353:	e8 c8 ca ff ff       	call   80101e20 <dirlink>
80105358:	83 c4 10             	add    $0x10,%esp
8010535b:	85 c0                	test   %eax,%eax
8010535d:	78 29                	js     80105388 <sys_link+0xe8>
  iunlockput(dp);
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	56                   	push   %esi
80105363:	e8 a8 c5 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105368:	89 1c 24             	mov    %ebx,(%esp)
8010536b:	e8 40 c4 ff ff       	call   801017b0 <iput>
  end_op();
80105370:	e8 9b d8 ff ff       	call   80102c10 <end_op>
  return 0;
80105375:	83 c4 10             	add    $0x10,%esp
80105378:	31 c0                	xor    %eax,%eax
}
8010537a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537d:	5b                   	pop    %ebx
8010537e:	5e                   	pop    %esi
8010537f:	5f                   	pop    %edi
80105380:	5d                   	pop    %ebp
80105381:	c3                   	ret    
80105382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	56                   	push   %esi
8010538c:	e8 7f c5 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105391:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105394:	83 ec 0c             	sub    $0xc,%esp
80105397:	53                   	push   %ebx
80105398:	e8 e3 c2 ff ff       	call   80101680 <ilock>
  ip->nlink--;
8010539d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053a2:	89 1c 24             	mov    %ebx,(%esp)
801053a5:	e8 26 c2 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801053aa:	89 1c 24             	mov    %ebx,(%esp)
801053ad:	e8 5e c5 ff ff       	call   80101910 <iunlockput>
  end_op();
801053b2:	e8 59 d8 ff ff       	call   80102c10 <end_op>
  return -1;
801053b7:	83 c4 10             	add    $0x10,%esp
}
801053ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801053bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5f                   	pop    %edi
801053c5:	5d                   	pop    %ebp
801053c6:	c3                   	ret    
    iunlockput(ip);
801053c7:	83 ec 0c             	sub    $0xc,%esp
801053ca:	53                   	push   %ebx
801053cb:	e8 40 c5 ff ff       	call   80101910 <iunlockput>
    end_op();
801053d0:	e8 3b d8 ff ff       	call   80102c10 <end_op>
    return -1;
801053d5:	83 c4 10             	add    $0x10,%esp
801053d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053dd:	eb 9b                	jmp    8010537a <sys_link+0xda>
    end_op();
801053df:	e8 2c d8 ff ff       	call   80102c10 <end_op>
    return -1;
801053e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e9:	eb 8f                	jmp    8010537a <sys_link+0xda>
801053eb:	90                   	nop
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_unlink>:
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801053f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801053fc:	50                   	push   %eax
801053fd:	6a 00                	push   $0x0
801053ff:	e8 1c fa ff ff       	call   80104e20 <argstr>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	85 c0                	test   %eax,%eax
80105409:	0f 88 77 01 00 00    	js     80105586 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010540f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105412:	e8 89 d7 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105417:	83 ec 08             	sub    $0x8,%esp
8010541a:	53                   	push   %ebx
8010541b:	ff 75 c0             	pushl  -0x40(%ebp)
8010541e:	e8 dd ca ff ff       	call   80101f00 <nameiparent>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	89 c6                	mov    %eax,%esi
8010542a:	0f 84 60 01 00 00    	je     80105590 <sys_unlink+0x1a0>
  ilock(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	50                   	push   %eax
80105434:	e8 47 c2 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105439:	58                   	pop    %eax
8010543a:	5a                   	pop    %edx
8010543b:	68 44 7e 10 80       	push   $0x80107e44
80105440:	53                   	push   %ebx
80105441:	e8 4a c7 ff ff       	call   80101b90 <namecmp>
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	85 c0                	test   %eax,%eax
8010544b:	0f 84 03 01 00 00    	je     80105554 <sys_unlink+0x164>
80105451:	83 ec 08             	sub    $0x8,%esp
80105454:	68 43 7e 10 80       	push   $0x80107e43
80105459:	53                   	push   %ebx
8010545a:	e8 31 c7 ff ff       	call   80101b90 <namecmp>
8010545f:	83 c4 10             	add    $0x10,%esp
80105462:	85 c0                	test   %eax,%eax
80105464:	0f 84 ea 00 00 00    	je     80105554 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010546a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010546d:	83 ec 04             	sub    $0x4,%esp
80105470:	50                   	push   %eax
80105471:	53                   	push   %ebx
80105472:	56                   	push   %esi
80105473:	e8 38 c7 ff ff       	call   80101bb0 <dirlookup>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	85 c0                	test   %eax,%eax
8010547d:	89 c3                	mov    %eax,%ebx
8010547f:	0f 84 cf 00 00 00    	je     80105554 <sys_unlink+0x164>
  ilock(ip);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	50                   	push   %eax
80105489:	e8 f2 c1 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105496:	0f 8e 10 01 00 00    	jle    801055ac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010549c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a1:	74 6d                	je     80105510 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801054a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054a6:	83 ec 04             	sub    $0x4,%esp
801054a9:	6a 10                	push   $0x10
801054ab:	6a 00                	push   $0x0
801054ad:	50                   	push   %eax
801054ae:	e8 bd f5 ff ff       	call   80104a70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054b6:	6a 10                	push   $0x10
801054b8:	ff 75 c4             	pushl  -0x3c(%ebp)
801054bb:	50                   	push   %eax
801054bc:	56                   	push   %esi
801054bd:	e8 9e c5 ff ff       	call   80101a60 <writei>
801054c2:	83 c4 20             	add    $0x20,%esp
801054c5:	83 f8 10             	cmp    $0x10,%eax
801054c8:	0f 85 eb 00 00 00    	jne    801055b9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801054ce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054d3:	0f 84 97 00 00 00    	je     80105570 <sys_unlink+0x180>
  iunlockput(dp);
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	56                   	push   %esi
801054dd:	e8 2e c4 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
801054e2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054e7:	89 1c 24             	mov    %ebx,(%esp)
801054ea:	e8 e1 c0 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801054ef:	89 1c 24             	mov    %ebx,(%esp)
801054f2:	e8 19 c4 ff ff       	call   80101910 <iunlockput>
  end_op();
801054f7:	e8 14 d7 ff ff       	call   80102c10 <end_op>
  return 0;
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	31 c0                	xor    %eax,%eax
}
80105501:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105504:	5b                   	pop    %ebx
80105505:	5e                   	pop    %esi
80105506:	5f                   	pop    %edi
80105507:	5d                   	pop    %ebp
80105508:	c3                   	ret    
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105510:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105514:	76 8d                	jbe    801054a3 <sys_unlink+0xb3>
80105516:	bf 20 00 00 00       	mov    $0x20,%edi
8010551b:	eb 0f                	jmp    8010552c <sys_unlink+0x13c>
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
80105520:	83 c7 10             	add    $0x10,%edi
80105523:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105526:	0f 83 77 ff ff ff    	jae    801054a3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010552c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010552f:	6a 10                	push   $0x10
80105531:	57                   	push   %edi
80105532:	50                   	push   %eax
80105533:	53                   	push   %ebx
80105534:	e8 27 c4 ff ff       	call   80101960 <readi>
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	83 f8 10             	cmp    $0x10,%eax
8010553f:	75 5e                	jne    8010559f <sys_unlink+0x1af>
    if(de.inum != 0)
80105541:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105546:	74 d8                	je     80105520 <sys_unlink+0x130>
    iunlockput(ip);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	53                   	push   %ebx
8010554c:	e8 bf c3 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105551:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	56                   	push   %esi
80105558:	e8 b3 c3 ff ff       	call   80101910 <iunlockput>
  end_op();
8010555d:	e8 ae d6 ff ff       	call   80102c10 <end_op>
  return -1;
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556a:	eb 95                	jmp    80105501 <sys_unlink+0x111>
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105570:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105575:	83 ec 0c             	sub    $0xc,%esp
80105578:	56                   	push   %esi
80105579:	e8 52 c0 ff ff       	call   801015d0 <iupdate>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	e9 53 ff ff ff       	jmp    801054d9 <sys_unlink+0xe9>
    return -1;
80105586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558b:	e9 71 ff ff ff       	jmp    80105501 <sys_unlink+0x111>
    end_op();
80105590:	e8 7b d6 ff ff       	call   80102c10 <end_op>
    return -1;
80105595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559a:	e9 62 ff ff ff       	jmp    80105501 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010559f:	83 ec 0c             	sub    $0xc,%esp
801055a2:	68 68 7e 10 80       	push   $0x80107e68
801055a7:	e8 e4 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801055ac:	83 ec 0c             	sub    $0xc,%esp
801055af:	68 56 7e 10 80       	push   $0x80107e56
801055b4:	e8 d7 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	68 7a 7e 10 80       	push   $0x80107e7a
801055c1:	e8 ca ad ff ff       	call   80100390 <panic>
801055c6:	8d 76 00             	lea    0x0(%esi),%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <sys_open>:

int
sys_open(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	57                   	push   %edi
801055d4:	56                   	push   %esi
801055d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055dc:	50                   	push   %eax
801055dd:	6a 00                	push   $0x0
801055df:	e8 3c f8 ff ff       	call   80104e20 <argstr>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	0f 88 1d 01 00 00    	js     8010570c <sys_open+0x13c>
801055ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055f2:	83 ec 08             	sub    $0x8,%esp
801055f5:	50                   	push   %eax
801055f6:	6a 01                	push   $0x1
801055f8:	e8 73 f7 ff ff       	call   80104d70 <argint>
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	85 c0                	test   %eax,%eax
80105602:	0f 88 04 01 00 00    	js     8010570c <sys_open+0x13c>
    return -1;

  begin_op();
80105608:	e8 93 d5 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
8010560d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105611:	0f 85 a9 00 00 00    	jne    801056c0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105617:	83 ec 0c             	sub    $0xc,%esp
8010561a:	ff 75 e0             	pushl  -0x20(%ebp)
8010561d:	e8 be c8 ff ff       	call   80101ee0 <namei>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	89 c6                	mov    %eax,%esi
80105629:	0f 84 b2 00 00 00    	je     801056e1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010562f:	83 ec 0c             	sub    $0xc,%esp
80105632:	50                   	push   %eax
80105633:	e8 48 c0 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105640:	0f 84 aa 00 00 00    	je     801056f0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105646:	e8 35 b7 ff ff       	call   80100d80 <filealloc>
8010564b:	85 c0                	test   %eax,%eax
8010564d:	89 c7                	mov    %eax,%edi
8010564f:	0f 84 a6 00 00 00    	je     801056fb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105655:	e8 16 e2 ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010565a:	31 db                	xor    %ebx,%ebx
8010565c:	eb 0e                	jmp    8010566c <sys_open+0x9c>
8010565e:	66 90                	xchg   %ax,%ax
80105660:	83 c3 01             	add    $0x1,%ebx
80105663:	83 fb 10             	cmp    $0x10,%ebx
80105666:	0f 84 ac 00 00 00    	je     80105718 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010566c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105670:	85 d2                	test   %edx,%edx
80105672:	75 ec                	jne    80105660 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105674:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105677:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010567b:	56                   	push   %esi
8010567c:	e8 df c0 ff ff       	call   80101760 <iunlock>
  end_op();
80105681:	e8 8a d5 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105686:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010568c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010568f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105692:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105695:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010569c:	89 d0                	mov    %edx,%eax
8010569e:	f7 d0                	not    %eax
801056a0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056a6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b0:	89 d8                	mov    %ebx,%eax
801056b2:	5b                   	pop    %ebx
801056b3:	5e                   	pop    %esi
801056b4:	5f                   	pop    %edi
801056b5:	5d                   	pop    %ebp
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056c6:	31 c9                	xor    %ecx,%ecx
801056c8:	6a 00                	push   $0x0
801056ca:	ba 02 00 00 00       	mov    $0x2,%edx
801056cf:	e8 ec f7 ff ff       	call   80104ec0 <create>
    if(ip == 0){
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801056d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056db:	0f 85 65 ff ff ff    	jne    80105646 <sys_open+0x76>
      end_op();
801056e1:	e8 2a d5 ff ff       	call   80102c10 <end_op>
      return -1;
801056e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056eb:	eb c0                	jmp    801056ad <sys_open+0xdd>
801056ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801056f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056f3:	85 c9                	test   %ecx,%ecx
801056f5:	0f 84 4b ff ff ff    	je     80105646 <sys_open+0x76>
    iunlockput(ip);
801056fb:	83 ec 0c             	sub    $0xc,%esp
801056fe:	56                   	push   %esi
801056ff:	e8 0c c2 ff ff       	call   80101910 <iunlockput>
    end_op();
80105704:	e8 07 d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105711:	eb 9a                	jmp    801056ad <sys_open+0xdd>
80105713:	90                   	nop
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	57                   	push   %edi
8010571c:	e8 1f b7 ff ff       	call   80100e40 <fileclose>
80105721:	83 c4 10             	add    $0x10,%esp
80105724:	eb d5                	jmp    801056fb <sys_open+0x12b>
80105726:	8d 76 00             	lea    0x0(%esi),%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_mkdir>:

int
sys_mkdir(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105736:	e8 65 d4 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010573b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573e:	83 ec 08             	sub    $0x8,%esp
80105741:	50                   	push   %eax
80105742:	6a 00                	push   $0x0
80105744:	e8 d7 f6 ff ff       	call   80104e20 <argstr>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	85 c0                	test   %eax,%eax
8010574e:	78 30                	js     80105780 <sys_mkdir+0x50>
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105756:	31 c9                	xor    %ecx,%ecx
80105758:	6a 00                	push   $0x0
8010575a:	ba 01 00 00 00       	mov    $0x1,%edx
8010575f:	e8 5c f7 ff ff       	call   80104ec0 <create>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	85 c0                	test   %eax,%eax
80105769:	74 15                	je     80105780 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010576b:	83 ec 0c             	sub    $0xc,%esp
8010576e:	50                   	push   %eax
8010576f:	e8 9c c1 ff ff       	call   80101910 <iunlockput>
  end_op();
80105774:	e8 97 d4 ff ff       	call   80102c10 <end_op>
  return 0;
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	31 c0                	xor    %eax,%eax
}
8010577e:	c9                   	leave  
8010577f:	c3                   	ret    
    end_op();
80105780:	e8 8b d4 ff ff       	call   80102c10 <end_op>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_mknod>:

int
sys_mknod(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105796:	e8 05 d4 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010579b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010579e:	83 ec 08             	sub    $0x8,%esp
801057a1:	50                   	push   %eax
801057a2:	6a 00                	push   $0x0
801057a4:	e8 77 f6 ff ff       	call   80104e20 <argstr>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 60                	js     80105810 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b3:	83 ec 08             	sub    $0x8,%esp
801057b6:	50                   	push   %eax
801057b7:	6a 01                	push   $0x1
801057b9:	e8 b2 f5 ff ff       	call   80104d70 <argint>
  if((argstr(0, &path)) < 0 ||
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	78 4b                	js     80105810 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801057c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c8:	83 ec 08             	sub    $0x8,%esp
801057cb:	50                   	push   %eax
801057cc:	6a 02                	push   $0x2
801057ce:	e8 9d f5 ff ff       	call   80104d70 <argint>
     argint(1, &major) < 0 ||
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	78 36                	js     80105810 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801057da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801057de:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801057e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801057e5:	ba 03 00 00 00       	mov    $0x3,%edx
801057ea:	50                   	push   %eax
801057eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057ee:	e8 cd f6 ff ff       	call   80104ec0 <create>
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	85 c0                	test   %eax,%eax
801057f8:	74 16                	je     80105810 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057fa:	83 ec 0c             	sub    $0xc,%esp
801057fd:	50                   	push   %eax
801057fe:	e8 0d c1 ff ff       	call   80101910 <iunlockput>
  end_op();
80105803:	e8 08 d4 ff ff       	call   80102c10 <end_op>
  return 0;
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	31 c0                	xor    %eax,%eax
}
8010580d:	c9                   	leave  
8010580e:	c3                   	ret    
8010580f:	90                   	nop
    end_op();
80105810:	e8 fb d3 ff ff       	call   80102c10 <end_op>
    return -1;
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010581a:	c9                   	leave  
8010581b:	c3                   	ret    
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_chdir>:

int
sys_chdir(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
80105825:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105828:	e8 43 e0 ff ff       	call   80103870 <myproc>
8010582d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010582f:	e8 6c d3 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105834:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	50                   	push   %eax
8010583b:	6a 00                	push   $0x0
8010583d:	e8 de f5 ff ff       	call   80104e20 <argstr>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	78 77                	js     801058c0 <sys_chdir+0xa0>
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	ff 75 f4             	pushl  -0xc(%ebp)
8010584f:	e8 8c c6 ff ff       	call   80101ee0 <namei>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	89 c3                	mov    %eax,%ebx
8010585b:	74 63                	je     801058c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	50                   	push   %eax
80105861:	e8 1a be ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010586e:	75 30                	jne    801058a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	53                   	push   %ebx
80105874:	e8 e7 be ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105879:	58                   	pop    %eax
8010587a:	ff 76 68             	pushl  0x68(%esi)
8010587d:	e8 2e bf ff ff       	call   801017b0 <iput>
  end_op();
80105882:	e8 89 d3 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105887:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	31 c0                	xor    %eax,%eax
}
8010588f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105892:	5b                   	pop    %ebx
80105893:	5e                   	pop    %esi
80105894:	5d                   	pop    %ebp
80105895:	c3                   	ret    
80105896:	8d 76 00             	lea    0x0(%esi),%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801058a0:	83 ec 0c             	sub    $0xc,%esp
801058a3:	53                   	push   %ebx
801058a4:	e8 67 c0 ff ff       	call   80101910 <iunlockput>
    end_op();
801058a9:	e8 62 d3 ff ff       	call   80102c10 <end_op>
    return -1;
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b6:	eb d7                	jmp    8010588f <sys_chdir+0x6f>
801058b8:	90                   	nop
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801058c0:	e8 4b d3 ff ff       	call   80102c10 <end_op>
    return -1;
801058c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ca:	eb c3                	jmp    8010588f <sys_chdir+0x6f>
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_exec>:

int
sys_exec(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
801058d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058e2:	50                   	push   %eax
801058e3:	6a 00                	push   $0x0
801058e5:	e8 36 f5 ff ff       	call   80104e20 <argstr>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	85 c0                	test   %eax,%eax
801058ef:	0f 88 87 00 00 00    	js     8010597c <sys_exec+0xac>
801058f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058fb:	83 ec 08             	sub    $0x8,%esp
801058fe:	50                   	push   %eax
801058ff:	6a 01                	push   $0x1
80105901:	e8 6a f4 ff ff       	call   80104d70 <argint>
80105906:	83 c4 10             	add    $0x10,%esp
80105909:	85 c0                	test   %eax,%eax
8010590b:	78 6f                	js     8010597c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010590d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105913:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105916:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105918:	68 80 00 00 00       	push   $0x80
8010591d:	6a 00                	push   $0x0
8010591f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105925:	50                   	push   %eax
80105926:	e8 45 f1 ff ff       	call   80104a70 <memset>
8010592b:	83 c4 10             	add    $0x10,%esp
8010592e:	eb 2c                	jmp    8010595c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105930:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105936:	85 c0                	test   %eax,%eax
80105938:	74 56                	je     80105990 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010593a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105940:	83 ec 08             	sub    $0x8,%esp
80105943:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105946:	52                   	push   %edx
80105947:	50                   	push   %eax
80105948:	e8 b3 f3 ff ff       	call   80104d00 <fetchstr>
8010594d:	83 c4 10             	add    $0x10,%esp
80105950:	85 c0                	test   %eax,%eax
80105952:	78 28                	js     8010597c <sys_exec+0xac>
  for(i=0;; i++){
80105954:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105957:	83 fb 20             	cmp    $0x20,%ebx
8010595a:	74 20                	je     8010597c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010595c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105962:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105969:	83 ec 08             	sub    $0x8,%esp
8010596c:	57                   	push   %edi
8010596d:	01 f0                	add    %esi,%eax
8010596f:	50                   	push   %eax
80105970:	e8 4b f3 ff ff       	call   80104cc0 <fetchint>
80105975:	83 c4 10             	add    $0x10,%esp
80105978:	85 c0                	test   %eax,%eax
8010597a:	79 b4                	jns    80105930 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010597c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010597f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105984:	5b                   	pop    %ebx
80105985:	5e                   	pop    %esi
80105986:	5f                   	pop    %edi
80105987:	5d                   	pop    %ebp
80105988:	c3                   	ret    
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105990:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105996:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105999:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059a0:	00 00 00 00 
  return exec(path, argv);
801059a4:	50                   	push   %eax
801059a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801059ab:	e8 60 b0 ff ff       	call   80100a10 <exec>
801059b0:	83 c4 10             	add    $0x10,%esp
}
801059b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b6:	5b                   	pop    %ebx
801059b7:	5e                   	pop    %esi
801059b8:	5f                   	pop    %edi
801059b9:	5d                   	pop    %ebp
801059ba:	c3                   	ret    
801059bb:	90                   	nop
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_pipe>:

int
sys_pipe(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	57                   	push   %edi
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059cc:	6a 08                	push   $0x8
801059ce:	50                   	push   %eax
801059cf:	6a 00                	push   $0x0
801059d1:	e8 ea f3 ff ff       	call   80104dc0 <argptr>
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	85 c0                	test   %eax,%eax
801059db:	0f 88 ae 00 00 00    	js     80105a8f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059e4:	83 ec 08             	sub    $0x8,%esp
801059e7:	50                   	push   %eax
801059e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059eb:	50                   	push   %eax
801059ec:	e8 4f d8 ff ff       	call   80103240 <pipealloc>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	0f 88 93 00 00 00    	js     80105a8f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a01:	e8 6a de ff ff       	call   80103870 <myproc>
80105a06:	eb 10                	jmp    80105a18 <sys_pipe+0x58>
80105a08:	90                   	nop
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a10:	83 c3 01             	add    $0x1,%ebx
80105a13:	83 fb 10             	cmp    $0x10,%ebx
80105a16:	74 60                	je     80105a78 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a18:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a1c:	85 f6                	test   %esi,%esi
80105a1e:	75 f0                	jne    80105a10 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a20:	8d 73 08             	lea    0x8(%ebx),%esi
80105a23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a2a:	e8 41 de ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a2f:	31 d2                	xor    %edx,%edx
80105a31:	eb 0d                	jmp    80105a40 <sys_pipe+0x80>
80105a33:	90                   	nop
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a38:	83 c2 01             	add    $0x1,%edx
80105a3b:	83 fa 10             	cmp    $0x10,%edx
80105a3e:	74 28                	je     80105a68 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105a40:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105a44:	85 c9                	test   %ecx,%ecx
80105a46:	75 f0                	jne    80105a38 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105a48:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a4f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a54:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a57:	31 c0                	xor    %eax,%eax
}
80105a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a5c:	5b                   	pop    %ebx
80105a5d:	5e                   	pop    %esi
80105a5e:	5f                   	pop    %edi
80105a5f:	5d                   	pop    %ebp
80105a60:	c3                   	ret    
80105a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105a68:	e8 03 de ff ff       	call   80103870 <myproc>
80105a6d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a74:	00 
80105a75:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	ff 75 e0             	pushl  -0x20(%ebp)
80105a7e:	e8 bd b3 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105a83:	58                   	pop    %eax
80105a84:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a87:	e8 b4 b3 ff ff       	call   80100e40 <fileclose>
    return -1;
80105a8c:	83 c4 10             	add    $0x10,%esp
80105a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a94:	eb c3                	jmp    80105a59 <sys_pipe+0x99>
80105a96:	66 90                	xchg   %ax,%ax
80105a98:	66 90                	xchg   %ax,%ax
80105a9a:	66 90                	xchg   %ax,%ax
80105a9c:	66 90                	xchg   %ax,%ax
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <sys_fork>:
#include "proc.h"
#include "userproc.h"

int
sys_fork(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105aa3:	5d                   	pop    %ebp
  return fork();
80105aa4:	e9 67 df ff ff       	jmp    80103a10 <fork>
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_exit>:

int
sys_exit(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ab6:	e8 85 e3 ff ff       	call   80103e40 <exit>
  return 0;  // not reached
}
80105abb:	31 c0                	xor    %eax,%eax
80105abd:	c9                   	leave  
80105abe:	c3                   	ret    
80105abf:	90                   	nop

80105ac0 <sys_wait>:

int
sys_wait(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ac3:	5d                   	pop    %ebp
  return wait();
80105ac4:	e9 f7 e5 ff ff       	jmp    801040c0 <wait>
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_waitx>:

int sys_waitx(void){  // taken from https://stackoverflow.com/questions/53383938/pass-struct-to-xv6-system-call
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime,*rtime;
  if(argptr(0,(char**)&wtime,sizeof(int))<0||argptr(1,(char**)&rtime,sizeof(int))<0) return -2;
80105ad6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad9:	6a 04                	push   $0x4
80105adb:	50                   	push   %eax
80105adc:	6a 00                	push   $0x0
80105ade:	e8 dd f2 ff ff       	call   80104dc0 <argptr>
80105ae3:	83 c4 10             	add    $0x10,%esp
80105ae6:	85 c0                	test   %eax,%eax
80105ae8:	78 2e                	js     80105b18 <sys_waitx+0x48>
80105aea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aed:	83 ec 04             	sub    $0x4,%esp
80105af0:	6a 04                	push   $0x4
80105af2:	50                   	push   %eax
80105af3:	6a 01                	push   $0x1
80105af5:	e8 c6 f2 ff ff       	call   80104dc0 <argptr>
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	85 c0                	test   %eax,%eax
80105aff:	78 17                	js     80105b18 <sys_waitx+0x48>
  return waitx(wtime, rtime);
80105b01:	83 ec 08             	sub    $0x8,%esp
80105b04:	ff 75 f4             	pushl  -0xc(%ebp)
80105b07:	ff 75 f0             	pushl  -0x10(%ebp)
80105b0a:	e8 b1 e6 ff ff       	call   801041c0 <waitx>
80105b0f:	83 c4 10             	add    $0x10,%esp
}
80105b12:	c9                   	leave  
80105b13:	c3                   	ret    
80105b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(argptr(0,(char**)&wtime,sizeof(int))<0||argptr(1,(char**)&rtime,sizeof(int))<0) return -2;
80105b18:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
80105b1d:	c9                   	leave  
80105b1e:	c3                   	ret    
80105b1f:	90                   	nop

80105b20 <sys_set_priority>:

int sys_set_priority(void){
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 1c             	sub    $0x1c,%esp
  int pid,priority;
  if(argptr(0,(char**)&pid,sizeof(int))<0||argptr(1,(char**)&priority,sizeof(int))<0) return -2;
80105b26:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b29:	6a 04                	push   $0x4
80105b2b:	50                   	push   %eax
80105b2c:	6a 00                	push   $0x0
80105b2e:	e8 8d f2 ff ff       	call   80104dc0 <argptr>
80105b33:	83 c4 10             	add    $0x10,%esp
80105b36:	85 c0                	test   %eax,%eax
80105b38:	78 2e                	js     80105b68 <sys_set_priority+0x48>
80105b3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b3d:	83 ec 04             	sub    $0x4,%esp
80105b40:	6a 04                	push   $0x4
80105b42:	50                   	push   %eax
80105b43:	6a 01                	push   $0x1
80105b45:	e8 76 f2 ff ff       	call   80104dc0 <argptr>
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	78 17                	js     80105b68 <sys_set_priority+0x48>
  return set_priority(pid,priority);
80105b51:	83 ec 08             	sub    $0x8,%esp
80105b54:	ff 75 f4             	pushl  -0xc(%ebp)
80105b57:	ff 75 f0             	pushl  -0x10(%ebp)
80105b5a:	e8 01 eb ff ff       	call   80104660 <set_priority>
80105b5f:	83 c4 10             	add    $0x10,%esp
}
80105b62:	c9                   	leave  
80105b63:	c3                   	ret    
80105b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(argptr(0,(char**)&pid,sizeof(int))<0||argptr(1,(char**)&priority,sizeof(int))<0) return -2;
80105b68:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
80105b6d:	c9                   	leave  
80105b6e:	c3                   	ret    
80105b6f:	90                   	nop

80105b70 <sys_kill>:

int
sys_kill(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b79:	50                   	push   %eax
80105b7a:	6a 00                	push   $0x0
80105b7c:	e8 ef f1 ff ff       	call   80104d70 <argint>
80105b81:	83 c4 10             	add    $0x10,%esp
80105b84:	85 c0                	test   %eax,%eax
80105b86:	78 18                	js     80105ba0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b8e:	e8 cd e7 ff ff       	call   80104360 <kill>
80105b93:	83 c4 10             	add    $0x10,%esp
}
80105b96:	c9                   	leave  
80105b97:	c3                   	ret    
80105b98:	90                   	nop
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba5:	c9                   	leave  
80105ba6:	c3                   	ret    
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bb0 <sys_getpinfo>:

int sys_getpinfo(void){
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 1c             	sub    $0x1c,%esp
  int pid; struct proc_stat *ps;
  if(argptr(0,(char**)&pid,sizeof(int))<0||argptr(1,(char**)&ps,sizeof(struct proc_stat))<0) return -2;
80105bb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb9:	6a 04                	push   $0x4
80105bbb:	50                   	push   %eax
80105bbc:	6a 00                	push   $0x0
80105bbe:	e8 fd f1 ff ff       	call   80104dc0 <argptr>
80105bc3:	83 c4 10             	add    $0x10,%esp
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	78 2e                	js     80105bf8 <sys_getpinfo+0x48>
80105bca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bcd:	83 ec 04             	sub    $0x4,%esp
80105bd0:	6a 24                	push   $0x24
80105bd2:	50                   	push   %eax
80105bd3:	6a 01                	push   $0x1
80105bd5:	e8 e6 f1 ff ff       	call   80104dc0 <argptr>
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	85 c0                	test   %eax,%eax
80105bdf:	78 17                	js     80105bf8 <sys_getpinfo+0x48>
  return getpinfo(pid,ps);
80105be1:	83 ec 08             	sub    $0x8,%esp
80105be4:	ff 75 f4             	pushl  -0xc(%ebp)
80105be7:	ff 75 f0             	pushl  -0x10(%ebp)
80105bea:	e8 c1 e9 ff ff       	call   801045b0 <getpinfo>
80105bef:	83 c4 10             	add    $0x10,%esp
}
80105bf2:	c9                   	leave  
80105bf3:	c3                   	ret    
80105bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(argptr(0,(char**)&pid,sizeof(int))<0||argptr(1,(char**)&ps,sizeof(struct proc_stat))<0) return -2;
80105bf8:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
80105bfd:	c9                   	leave  
80105bfe:	c3                   	ret    
80105bff:	90                   	nop

80105c00 <sys_getticks>:

int sys_getticks(void){
80105c00:	55                   	push   %ebp
  return ticks;
}
80105c01:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
int sys_getticks(void){
80105c06:	89 e5                	mov    %esp,%ebp
}
80105c08:	5d                   	pop    %ebp
80105c09:	c3                   	ret    
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c10 <sys_getpid>:

int
sys_getpid(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c16:	e8 55 dc ff ff       	call   80103870 <myproc>
80105c1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c1e:	c9                   	leave  
80105c1f:	c3                   	ret    

80105c20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c2a:	50                   	push   %eax
80105c2b:	6a 00                	push   $0x0
80105c2d:	e8 3e f1 ff ff       	call   80104d70 <argint>
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	85 c0                	test   %eax,%eax
80105c37:	78 27                	js     80105c60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c39:	e8 32 dc ff ff       	call   80103870 <myproc>
  if(growproc(n) < 0)
80105c3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c43:	ff 75 f4             	pushl  -0xc(%ebp)
80105c46:	e8 45 dd ff ff       	call   80103990 <growproc>
80105c4b:	83 c4 10             	add    $0x10,%esp
80105c4e:	85 c0                	test   %eax,%eax
80105c50:	78 0e                	js     80105c60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c52:	89 d8                	mov    %ebx,%eax
80105c54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c57:	c9                   	leave  
80105c58:	c3                   	ret    
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c65:	eb eb                	jmp    80105c52 <sys_sbrk+0x32>
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <sys_sleep>:

int
sys_sleep(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c7a:	50                   	push   %eax
80105c7b:	6a 00                	push   $0x0
80105c7d:	e8 ee f0 ff ff       	call   80104d70 <argint>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	0f 88 8a 00 00 00    	js     80105d17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	68 a0 65 11 80       	push   $0x801165a0
80105c95:	e8 c6 ec ff ff       	call   80104960 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c9d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105ca0:	8b 1d e0 6d 11 80    	mov    0x80116de0,%ebx
  while(ticks - ticks0 < n){
80105ca6:	85 d2                	test   %edx,%edx
80105ca8:	75 27                	jne    80105cd1 <sys_sleep+0x61>
80105caa:	eb 54                	jmp    80105d00 <sys_sleep+0x90>
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105cb0:	83 ec 08             	sub    $0x8,%esp
80105cb3:	68 a0 65 11 80       	push   $0x801165a0
80105cb8:	68 e0 6d 11 80       	push   $0x80116de0
80105cbd:	e8 3e e3 ff ff       	call   80104000 <sleep>
  while(ticks - ticks0 < n){
80105cc2:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
80105cc7:	83 c4 10             	add    $0x10,%esp
80105cca:	29 d8                	sub    %ebx,%eax
80105ccc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105ccf:	73 2f                	jae    80105d00 <sys_sleep+0x90>
    if(myproc()->killed){
80105cd1:	e8 9a db ff ff       	call   80103870 <myproc>
80105cd6:	8b 40 24             	mov    0x24(%eax),%eax
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	74 d3                	je     80105cb0 <sys_sleep+0x40>
      release(&tickslock);
80105cdd:	83 ec 0c             	sub    $0xc,%esp
80105ce0:	68 a0 65 11 80       	push   $0x801165a0
80105ce5:	e8 36 ed ff ff       	call   80104a20 <release>
      return -1;
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105cf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105d00:	83 ec 0c             	sub    $0xc,%esp
80105d03:	68 a0 65 11 80       	push   $0x801165a0
80105d08:	e8 13 ed ff ff       	call   80104a20 <release>
  return 0;
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	31 c0                	xor    %eax,%eax
}
80105d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
    return -1;
80105d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1c:	eb f4                	jmp    80105d12 <sys_sleep+0xa2>
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
80105d24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d27:	68 a0 65 11 80       	push   $0x801165a0
80105d2c:	e8 2f ec ff ff       	call   80104960 <acquire>
  xticks = ticks;
80105d31:	8b 1d e0 6d 11 80    	mov    0x80116de0,%ebx
  release(&tickslock);
80105d37:	c7 04 24 a0 65 11 80 	movl   $0x801165a0,(%esp)
80105d3e:	e8 dd ec ff ff       	call   80104a20 <release>
  return xticks;
}
80105d43:	89 d8                	mov    %ebx,%eax
80105d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d48:	c9                   	leave  
80105d49:	c3                   	ret    

80105d4a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d4a:	1e                   	push   %ds
  pushl %es
80105d4b:	06                   	push   %es
  pushl %fs
80105d4c:	0f a0                	push   %fs
  pushl %gs
80105d4e:	0f a8                	push   %gs
  pushal
80105d50:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d51:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d55:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d57:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d59:	54                   	push   %esp
  call trap
80105d5a:	e8 c1 00 00 00       	call   80105e20 <trap>
  addl $4, %esp
80105d5f:	83 c4 04             	add    $0x4,%esp

80105d62 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d62:	61                   	popa   
  popl %gs
80105d63:	0f a9                	pop    %gs
  popl %fs
80105d65:	0f a1                	pop    %fs
  popl %es
80105d67:	07                   	pop    %es
  popl %ds
80105d68:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d69:	83 c4 08             	add    $0x8,%esp
  iret
80105d6c:	cf                   	iret   
80105d6d:	66 90                	xchg   %ax,%ax
80105d6f:	90                   	nop

80105d70 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d70:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d71:	31 c0                	xor    %eax,%eax
{
80105d73:	89 e5                	mov    %esp,%ebp
80105d75:	83 ec 08             	sub    $0x8,%esp
80105d78:	90                   	nop
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d80:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d87:	c7 04 c5 e2 65 11 80 	movl   $0x8e000008,-0x7fee9a1e(,%eax,8)
80105d8e:	08 00 00 8e 
80105d92:	66 89 14 c5 e0 65 11 	mov    %dx,-0x7fee9a20(,%eax,8)
80105d99:	80 
80105d9a:	c1 ea 10             	shr    $0x10,%edx
80105d9d:	66 89 14 c5 e6 65 11 	mov    %dx,-0x7fee9a1a(,%eax,8)
80105da4:	80 
  for(i = 0; i < 256; i++)
80105da5:	83 c0 01             	add    $0x1,%eax
80105da8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105dad:	75 d1                	jne    80105d80 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105daf:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105db4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105db7:	c7 05 e2 67 11 80 08 	movl   $0xef000008,0x801167e2
80105dbe:	00 00 ef 
  initlock(&tickslock, "time");
80105dc1:	68 89 7e 10 80       	push   $0x80107e89
80105dc6:	68 a0 65 11 80       	push   $0x801165a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dcb:	66 a3 e0 67 11 80    	mov    %ax,0x801167e0
80105dd1:	c1 e8 10             	shr    $0x10,%eax
80105dd4:	66 a3 e6 67 11 80    	mov    %ax,0x801167e6
  initlock(&tickslock, "time");
80105dda:	e8 41 ea ff ff       	call   80104820 <initlock>
}
80105ddf:	83 c4 10             	add    $0x10,%esp
80105de2:	c9                   	leave  
80105de3:	c3                   	ret    
80105de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105df0 <idtinit>:

void
idtinit(void)
{
80105df0:	55                   	push   %ebp
  pd[0] = size-1;
80105df1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105df6:	89 e5                	mov    %esp,%ebp
80105df8:	83 ec 10             	sub    $0x10,%esp
80105dfb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105dff:	b8 e0 65 11 80       	mov    $0x801165e0,%eax
80105e04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e08:	c1 e8 10             	shr    $0x10,%eax
80105e0b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e0f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e12:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e15:	c9                   	leave  
80105e16:	c3                   	ret    
80105e17:	89 f6                	mov    %esi,%esi
80105e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	57                   	push   %edi
80105e24:	56                   	push   %esi
80105e25:	53                   	push   %ebx
80105e26:	83 ec 1c             	sub    $0x1c,%esp
80105e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105e2c:	8b 47 30             	mov    0x30(%edi),%eax
80105e2f:	83 f8 40             	cmp    $0x40,%eax
80105e32:	0f 84 10 01 00 00    	je     80105f48 <trap+0x128>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e38:	83 e8 20             	sub    $0x20,%eax
80105e3b:	83 f8 1f             	cmp    $0x1f,%eax
80105e3e:	77 10                	ja     80105e50 <trap+0x30>
80105e40:	ff 24 85 30 7f 10 80 	jmp    *-0x7fef80d0(,%eax,4)
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e50:	e8 1b da ff ff       	call   80103870 <myproc>
80105e55:	85 c0                	test   %eax,%eax
80105e57:	8b 5f 38             	mov    0x38(%edi),%ebx
80105e5a:	0f 84 81 02 00 00    	je     801060e1 <trap+0x2c1>
80105e60:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105e64:	0f 84 77 02 00 00    	je     801060e1 <trap+0x2c1>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e6a:	0f 20 d1             	mov    %cr2,%ecx
80105e6d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e70:	e8 db d9 ff ff       	call   80103850 <cpuid>
80105e75:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e78:	8b 47 34             	mov    0x34(%edi),%eax
80105e7b:	8b 77 30             	mov    0x30(%edi),%esi
80105e7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105e81:	e8 ea d9 ff ff       	call   80103870 <myproc>
80105e86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e89:	e8 e2 d9 ff ff       	call   80103870 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e8e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e94:	51                   	push   %ecx
80105e95:	53                   	push   %ebx
80105e96:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105e97:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e9a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e9d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e9e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ea1:	52                   	push   %edx
80105ea2:	ff 70 10             	pushl  0x10(%eax)
80105ea5:	68 ec 7e 10 80       	push   $0x80107eec
80105eaa:	e8 b1 a7 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105eaf:	83 c4 20             	add    $0x20,%esp
80105eb2:	e8 b9 d9 ff ff       	call   80103870 <myproc>
80105eb7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ebe:	e8 ad d9 ff ff       	call   80103870 <myproc>
80105ec3:	85 c0                	test   %eax,%eax
80105ec5:	74 1d                	je     80105ee4 <trap+0xc4>
80105ec7:	e8 a4 d9 ff ff       	call   80103870 <myproc>
80105ecc:	8b 48 24             	mov    0x24(%eax),%ecx
80105ecf:	85 c9                	test   %ecx,%ecx
80105ed1:	74 11                	je     80105ee4 <trap+0xc4>
80105ed3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ed7:	83 e0 03             	and    $0x3,%eax
80105eda:	66 83 f8 03          	cmp    $0x3,%ax
80105ede:	0f 84 9c 01 00 00    	je     80106080 <trap+0x260>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if((myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER))
80105ee4:	e8 87 d9 ff ff       	call   80103870 <myproc>
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	74 0f                	je     80105efc <trap+0xdc>
80105eed:	e8 7e d9 ff ff       	call   80103870 <myproc>
80105ef2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ef6:	0f 84 84 00 00 00    	je     80105f80 <trap+0x160>
    yield();

  if(myproc() && (myproc()->canruntill<=0 && myproc()->pid>2)){
80105efc:	e8 6f d9 ff ff       	call   80103870 <myproc>
80105f01:	85 c0                	test   %eax,%eax
80105f03:	74 13                	je     80105f18 <trap+0xf8>
80105f05:	e8 66 d9 ff ff       	call   80103870 <myproc>
80105f0a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105f10:	85 d2                	test   %edx,%edx
80105f12:	0f 8e 30 01 00 00    	jle    80106048 <trap+0x228>
    if(myproc()->pqlvl<4) myproc()->pqlvl++;
    yield();
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f18:	e8 53 d9 ff ff       	call   80103870 <myproc>
80105f1d:	85 c0                	test   %eax,%eax
80105f1f:	74 19                	je     80105f3a <trap+0x11a>
80105f21:	e8 4a d9 ff ff       	call   80103870 <myproc>
80105f26:	8b 40 24             	mov    0x24(%eax),%eax
80105f29:	85 c0                	test   %eax,%eax
80105f2b:	74 0d                	je     80105f3a <trap+0x11a>
80105f2d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f31:	83 e0 03             	and    $0x3,%eax
80105f34:	66 83 f8 03          	cmp    $0x3,%ax
80105f38:	74 37                	je     80105f71 <trap+0x151>
    exit();
}
80105f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f3d:	5b                   	pop    %ebx
80105f3e:	5e                   	pop    %esi
80105f3f:	5f                   	pop    %edi
80105f40:	5d                   	pop    %ebp
80105f41:	c3                   	ret    
80105f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105f48:	e8 23 d9 ff ff       	call   80103870 <myproc>
80105f4d:	8b 70 24             	mov    0x24(%eax),%esi
80105f50:	85 f6                	test   %esi,%esi
80105f52:	0f 85 18 01 00 00    	jne    80106070 <trap+0x250>
    myproc()->tf = tf;
80105f58:	e8 13 d9 ff ff       	call   80103870 <myproc>
80105f5d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105f60:	e8 fb ee ff ff       	call   80104e60 <syscall>
    if(myproc()->killed)
80105f65:	e8 06 d9 ff ff       	call   80103870 <myproc>
80105f6a:	8b 58 24             	mov    0x24(%eax),%ebx
80105f6d:	85 db                	test   %ebx,%ebx
80105f6f:	74 c9                	je     80105f3a <trap+0x11a>
}
80105f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f74:	5b                   	pop    %ebx
80105f75:	5e                   	pop    %esi
80105f76:	5f                   	pop    %edi
80105f77:	5d                   	pop    %ebp
      exit();
80105f78:	e9 c3 de ff ff       	jmp    80103e40 <exit>
80105f7d:	8d 76 00             	lea    0x0(%esi),%esi
  if((myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER))
80105f80:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105f84:	0f 85 72 ff ff ff    	jne    80105efc <trap+0xdc>
    yield();
80105f8a:	e8 21 e0 ff ff       	call   80103fb0 <yield>
80105f8f:	e9 68 ff ff ff       	jmp    80105efc <trap+0xdc>
80105f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105f98:	e8 b3 d8 ff ff       	call   80103850 <cpuid>
80105f9d:	85 c0                	test   %eax,%eax
80105f9f:	0f 84 eb 00 00 00    	je     80106090 <trap+0x270>
    lapiceoi();
80105fa5:	e8 a6 c7 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105faa:	e8 c1 d8 ff ff       	call   80103870 <myproc>
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	0f 85 10 ff ff ff    	jne    80105ec7 <trap+0xa7>
80105fb7:	e9 28 ff ff ff       	jmp    80105ee4 <trap+0xc4>
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fc0:	e8 4b c6 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
80105fc5:	e8 86 c7 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fca:	e8 a1 d8 ff ff       	call   80103870 <myproc>
80105fcf:	85 c0                	test   %eax,%eax
80105fd1:	0f 85 f0 fe ff ff    	jne    80105ec7 <trap+0xa7>
80105fd7:	e9 08 ff ff ff       	jmp    80105ee4 <trap+0xc4>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fe0:	e8 9b 02 00 00       	call   80106280 <uartintr>
    lapiceoi();
80105fe5:	e8 66 c7 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fea:	e8 81 d8 ff ff       	call   80103870 <myproc>
80105fef:	85 c0                	test   %eax,%eax
80105ff1:	0f 85 d0 fe ff ff    	jne    80105ec7 <trap+0xa7>
80105ff7:	e9 e8 fe ff ff       	jmp    80105ee4 <trap+0xc4>
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106000:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106004:	8b 77 38             	mov    0x38(%edi),%esi
80106007:	e8 44 d8 ff ff       	call   80103850 <cpuid>
8010600c:	56                   	push   %esi
8010600d:	53                   	push   %ebx
8010600e:	50                   	push   %eax
8010600f:	68 94 7e 10 80       	push   $0x80107e94
80106014:	e8 47 a6 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106019:	e8 32 c7 ff ff       	call   80102750 <lapiceoi>
    break;
8010601e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106021:	e8 4a d8 ff ff       	call   80103870 <myproc>
80106026:	85 c0                	test   %eax,%eax
80106028:	0f 85 99 fe ff ff    	jne    80105ec7 <trap+0xa7>
8010602e:	e9 b1 fe ff ff       	jmp    80105ee4 <trap+0xc4>
80106033:	90                   	nop
80106034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106038:	e8 43 c0 ff ff       	call   80102080 <ideintr>
8010603d:	e9 63 ff ff ff       	jmp    80105fa5 <trap+0x185>
80106042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && (myproc()->canruntill<=0 && myproc()->pid>2)){
80106048:	e8 23 d8 ff ff       	call   80103870 <myproc>
8010604d:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106051:	0f 8e c1 fe ff ff    	jle    80105f18 <trap+0xf8>
    if(myproc()->pqlvl<4) myproc()->pqlvl++;
80106057:	e8 14 d8 ff ff       	call   80103870 <myproc>
8010605c:	83 b8 8c 00 00 00 03 	cmpl   $0x3,0x8c(%eax)
80106063:	7e 6b                	jle    801060d0 <trap+0x2b0>
    yield();
80106065:	e8 46 df ff ff       	call   80103fb0 <yield>
8010606a:	e9 a9 fe ff ff       	jmp    80105f18 <trap+0xf8>
8010606f:	90                   	nop
      exit();
80106070:	e8 cb dd ff ff       	call   80103e40 <exit>
80106075:	e9 de fe ff ff       	jmp    80105f58 <trap+0x138>
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106080:	e8 bb dd ff ff       	call   80103e40 <exit>
80106085:	e9 5a fe ff ff       	jmp    80105ee4 <trap+0xc4>
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	68 a0 65 11 80       	push   $0x801165a0
80106098:	e8 c3 e8 ff ff       	call   80104960 <acquire>
      ticks++;
8010609d:	83 05 e0 6d 11 80 01 	addl   $0x1,0x80116de0
      uprtime();
801060a4:	e8 07 e4 ff ff       	call   801044b0 <uprtime>
      wakeup(&ticks);
801060a9:	c7 04 24 e0 6d 11 80 	movl   $0x80116de0,(%esp)
801060b0:	e8 4b e2 ff ff       	call   80104300 <wakeup>
      release(&tickslock);
801060b5:	c7 04 24 a0 65 11 80 	movl   $0x801165a0,(%esp)
801060bc:	e8 5f e9 ff ff       	call   80104a20 <release>
801060c1:	83 c4 10             	add    $0x10,%esp
801060c4:	e9 dc fe ff ff       	jmp    80105fa5 <trap+0x185>
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->pqlvl<4) myproc()->pqlvl++;
801060d0:	e8 9b d7 ff ff       	call   80103870 <myproc>
801060d5:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
801060dc:	e9 84 ff ff ff       	jmp    80106065 <trap+0x245>
801060e1:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060e4:	e8 67 d7 ff ff       	call   80103850 <cpuid>
801060e9:	83 ec 0c             	sub    $0xc,%esp
801060ec:	56                   	push   %esi
801060ed:	53                   	push   %ebx
801060ee:	50                   	push   %eax
801060ef:	ff 77 30             	pushl  0x30(%edi)
801060f2:	68 b8 7e 10 80       	push   $0x80107eb8
801060f7:	e8 64 a5 ff ff       	call   80100660 <cprintf>
      panic("trap");
801060fc:	83 c4 14             	add    $0x14,%esp
801060ff:	68 8e 7e 10 80       	push   $0x80107e8e
80106104:	e8 87 a2 ff ff       	call   80100390 <panic>
80106109:	66 90                	xchg   %ax,%ax
8010610b:	66 90                	xchg   %ax,%ax
8010610d:	66 90                	xchg   %ax,%ax
8010610f:	90                   	nop

80106110 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106110:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106115:	55                   	push   %ebp
80106116:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106118:	85 c0                	test   %eax,%eax
8010611a:	74 1c                	je     80106138 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010611c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106121:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106122:	a8 01                	test   $0x1,%al
80106124:	74 12                	je     80106138 <uartgetc+0x28>
80106126:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010612b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010612c:	0f b6 c0             	movzbl %al,%eax
}
8010612f:	5d                   	pop    %ebp
80106130:	c3                   	ret    
80106131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010613d:	5d                   	pop    %ebp
8010613e:	c3                   	ret    
8010613f:	90                   	nop

80106140 <uartputc.part.0>:
uartputc(int c)
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	57                   	push   %edi
80106144:	56                   	push   %esi
80106145:	53                   	push   %ebx
80106146:	89 c7                	mov    %eax,%edi
80106148:	bb 80 00 00 00       	mov    $0x80,%ebx
8010614d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106152:	83 ec 0c             	sub    $0xc,%esp
80106155:	eb 1b                	jmp    80106172 <uartputc.part.0+0x32>
80106157:	89 f6                	mov    %esi,%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	6a 0a                	push   $0xa
80106165:	e8 06 c6 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010616a:	83 c4 10             	add    $0x10,%esp
8010616d:	83 eb 01             	sub    $0x1,%ebx
80106170:	74 07                	je     80106179 <uartputc.part.0+0x39>
80106172:	89 f2                	mov    %esi,%edx
80106174:	ec                   	in     (%dx),%al
80106175:	a8 20                	test   $0x20,%al
80106177:	74 e7                	je     80106160 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106179:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010617e:	89 f8                	mov    %edi,%eax
80106180:	ee                   	out    %al,(%dx)
}
80106181:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106184:	5b                   	pop    %ebx
80106185:	5e                   	pop    %esi
80106186:	5f                   	pop    %edi
80106187:	5d                   	pop    %ebp
80106188:	c3                   	ret    
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106190 <uartinit>:
{
80106190:	55                   	push   %ebp
80106191:	31 c9                	xor    %ecx,%ecx
80106193:	89 c8                	mov    %ecx,%eax
80106195:	89 e5                	mov    %esp,%ebp
80106197:	57                   	push   %edi
80106198:	56                   	push   %esi
80106199:	53                   	push   %ebx
8010619a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010619f:	89 da                	mov    %ebx,%edx
801061a1:	83 ec 0c             	sub    $0xc,%esp
801061a4:	ee                   	out    %al,(%dx)
801061a5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801061aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801061af:	89 fa                	mov    %edi,%edx
801061b1:	ee                   	out    %al,(%dx)
801061b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801061b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061bc:	ee                   	out    %al,(%dx)
801061bd:	be f9 03 00 00       	mov    $0x3f9,%esi
801061c2:	89 c8                	mov    %ecx,%eax
801061c4:	89 f2                	mov    %esi,%edx
801061c6:	ee                   	out    %al,(%dx)
801061c7:	b8 03 00 00 00       	mov    $0x3,%eax
801061cc:	89 fa                	mov    %edi,%edx
801061ce:	ee                   	out    %al,(%dx)
801061cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801061d4:	89 c8                	mov    %ecx,%eax
801061d6:	ee                   	out    %al,(%dx)
801061d7:	b8 01 00 00 00       	mov    $0x1,%eax
801061dc:	89 f2                	mov    %esi,%edx
801061de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801061e5:	3c ff                	cmp    $0xff,%al
801061e7:	74 5a                	je     80106243 <uartinit+0xb3>
  uart = 1;
801061e9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801061f0:	00 00 00 
801061f3:	89 da                	mov    %ebx,%edx
801061f5:	ec                   	in     (%dx),%al
801061f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801061fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801061ff:	bb b0 7f 10 80       	mov    $0x80107fb0,%ebx
  ioapicenable(IRQ_COM1, 0);
80106204:	6a 00                	push   $0x0
80106206:	6a 04                	push   $0x4
80106208:	e8 c3 c0 ff ff       	call   801022d0 <ioapicenable>
8010620d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106210:	b8 78 00 00 00       	mov    $0x78,%eax
80106215:	eb 13                	jmp    8010622a <uartinit+0x9a>
80106217:	89 f6                	mov    %esi,%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106220:	83 c3 01             	add    $0x1,%ebx
80106223:	0f be 03             	movsbl (%ebx),%eax
80106226:	84 c0                	test   %al,%al
80106228:	74 19                	je     80106243 <uartinit+0xb3>
  if(!uart)
8010622a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106230:	85 d2                	test   %edx,%edx
80106232:	74 ec                	je     80106220 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106234:	83 c3 01             	add    $0x1,%ebx
80106237:	e8 04 ff ff ff       	call   80106140 <uartputc.part.0>
8010623c:	0f be 03             	movsbl (%ebx),%eax
8010623f:	84 c0                	test   %al,%al
80106241:	75 e7                	jne    8010622a <uartinit+0x9a>
}
80106243:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106246:	5b                   	pop    %ebx
80106247:	5e                   	pop    %esi
80106248:	5f                   	pop    %edi
80106249:	5d                   	pop    %ebp
8010624a:	c3                   	ret    
8010624b:	90                   	nop
8010624c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106250 <uartputc>:
  if(!uart)
80106250:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106256:	55                   	push   %ebp
80106257:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106259:	85 d2                	test   %edx,%edx
{
8010625b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010625e:	74 10                	je     80106270 <uartputc+0x20>
}
80106260:	5d                   	pop    %ebp
80106261:	e9 da fe ff ff       	jmp    80106140 <uartputc.part.0>
80106266:	8d 76 00             	lea    0x0(%esi),%esi
80106269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106270:	5d                   	pop    %ebp
80106271:	c3                   	ret    
80106272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106280 <uartintr>:

void
uartintr(void)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106286:	68 10 61 10 80       	push   $0x80106110
8010628b:	e8 80 a5 ff ff       	call   80100810 <consoleintr>
}
80106290:	83 c4 10             	add    $0x10,%esp
80106293:	c9                   	leave  
80106294:	c3                   	ret    

80106295 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $0
80106297:	6a 00                	push   $0x0
  jmp alltraps
80106299:	e9 ac fa ff ff       	jmp    80105d4a <alltraps>

8010629e <vector1>:
.globl vector1
vector1:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $1
801062a0:	6a 01                	push   $0x1
  jmp alltraps
801062a2:	e9 a3 fa ff ff       	jmp    80105d4a <alltraps>

801062a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $2
801062a9:	6a 02                	push   $0x2
  jmp alltraps
801062ab:	e9 9a fa ff ff       	jmp    80105d4a <alltraps>

801062b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $3
801062b2:	6a 03                	push   $0x3
  jmp alltraps
801062b4:	e9 91 fa ff ff       	jmp    80105d4a <alltraps>

801062b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $4
801062bb:	6a 04                	push   $0x4
  jmp alltraps
801062bd:	e9 88 fa ff ff       	jmp    80105d4a <alltraps>

801062c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $5
801062c4:	6a 05                	push   $0x5
  jmp alltraps
801062c6:	e9 7f fa ff ff       	jmp    80105d4a <alltraps>

801062cb <vector6>:
.globl vector6
vector6:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $6
801062cd:	6a 06                	push   $0x6
  jmp alltraps
801062cf:	e9 76 fa ff ff       	jmp    80105d4a <alltraps>

801062d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $7
801062d6:	6a 07                	push   $0x7
  jmp alltraps
801062d8:	e9 6d fa ff ff       	jmp    80105d4a <alltraps>

801062dd <vector8>:
.globl vector8
vector8:
  pushl $8
801062dd:	6a 08                	push   $0x8
  jmp alltraps
801062df:	e9 66 fa ff ff       	jmp    80105d4a <alltraps>

801062e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $9
801062e6:	6a 09                	push   $0x9
  jmp alltraps
801062e8:	e9 5d fa ff ff       	jmp    80105d4a <alltraps>

801062ed <vector10>:
.globl vector10
vector10:
  pushl $10
801062ed:	6a 0a                	push   $0xa
  jmp alltraps
801062ef:	e9 56 fa ff ff       	jmp    80105d4a <alltraps>

801062f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062f4:	6a 0b                	push   $0xb
  jmp alltraps
801062f6:	e9 4f fa ff ff       	jmp    80105d4a <alltraps>

801062fb <vector12>:
.globl vector12
vector12:
  pushl $12
801062fb:	6a 0c                	push   $0xc
  jmp alltraps
801062fd:	e9 48 fa ff ff       	jmp    80105d4a <alltraps>

80106302 <vector13>:
.globl vector13
vector13:
  pushl $13
80106302:	6a 0d                	push   $0xd
  jmp alltraps
80106304:	e9 41 fa ff ff       	jmp    80105d4a <alltraps>

80106309 <vector14>:
.globl vector14
vector14:
  pushl $14
80106309:	6a 0e                	push   $0xe
  jmp alltraps
8010630b:	e9 3a fa ff ff       	jmp    80105d4a <alltraps>

80106310 <vector15>:
.globl vector15
vector15:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $15
80106312:	6a 0f                	push   $0xf
  jmp alltraps
80106314:	e9 31 fa ff ff       	jmp    80105d4a <alltraps>

80106319 <vector16>:
.globl vector16
vector16:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $16
8010631b:	6a 10                	push   $0x10
  jmp alltraps
8010631d:	e9 28 fa ff ff       	jmp    80105d4a <alltraps>

80106322 <vector17>:
.globl vector17
vector17:
  pushl $17
80106322:	6a 11                	push   $0x11
  jmp alltraps
80106324:	e9 21 fa ff ff       	jmp    80105d4a <alltraps>

80106329 <vector18>:
.globl vector18
vector18:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $18
8010632b:	6a 12                	push   $0x12
  jmp alltraps
8010632d:	e9 18 fa ff ff       	jmp    80105d4a <alltraps>

80106332 <vector19>:
.globl vector19
vector19:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $19
80106334:	6a 13                	push   $0x13
  jmp alltraps
80106336:	e9 0f fa ff ff       	jmp    80105d4a <alltraps>

8010633b <vector20>:
.globl vector20
vector20:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $20
8010633d:	6a 14                	push   $0x14
  jmp alltraps
8010633f:	e9 06 fa ff ff       	jmp    80105d4a <alltraps>

80106344 <vector21>:
.globl vector21
vector21:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $21
80106346:	6a 15                	push   $0x15
  jmp alltraps
80106348:	e9 fd f9 ff ff       	jmp    80105d4a <alltraps>

8010634d <vector22>:
.globl vector22
vector22:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $22
8010634f:	6a 16                	push   $0x16
  jmp alltraps
80106351:	e9 f4 f9 ff ff       	jmp    80105d4a <alltraps>

80106356 <vector23>:
.globl vector23
vector23:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $23
80106358:	6a 17                	push   $0x17
  jmp alltraps
8010635a:	e9 eb f9 ff ff       	jmp    80105d4a <alltraps>

8010635f <vector24>:
.globl vector24
vector24:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $24
80106361:	6a 18                	push   $0x18
  jmp alltraps
80106363:	e9 e2 f9 ff ff       	jmp    80105d4a <alltraps>

80106368 <vector25>:
.globl vector25
vector25:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $25
8010636a:	6a 19                	push   $0x19
  jmp alltraps
8010636c:	e9 d9 f9 ff ff       	jmp    80105d4a <alltraps>

80106371 <vector26>:
.globl vector26
vector26:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $26
80106373:	6a 1a                	push   $0x1a
  jmp alltraps
80106375:	e9 d0 f9 ff ff       	jmp    80105d4a <alltraps>

8010637a <vector27>:
.globl vector27
vector27:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $27
8010637c:	6a 1b                	push   $0x1b
  jmp alltraps
8010637e:	e9 c7 f9 ff ff       	jmp    80105d4a <alltraps>

80106383 <vector28>:
.globl vector28
vector28:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $28
80106385:	6a 1c                	push   $0x1c
  jmp alltraps
80106387:	e9 be f9 ff ff       	jmp    80105d4a <alltraps>

8010638c <vector29>:
.globl vector29
vector29:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $29
8010638e:	6a 1d                	push   $0x1d
  jmp alltraps
80106390:	e9 b5 f9 ff ff       	jmp    80105d4a <alltraps>

80106395 <vector30>:
.globl vector30
vector30:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $30
80106397:	6a 1e                	push   $0x1e
  jmp alltraps
80106399:	e9 ac f9 ff ff       	jmp    80105d4a <alltraps>

8010639e <vector31>:
.globl vector31
vector31:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $31
801063a0:	6a 1f                	push   $0x1f
  jmp alltraps
801063a2:	e9 a3 f9 ff ff       	jmp    80105d4a <alltraps>

801063a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $32
801063a9:	6a 20                	push   $0x20
  jmp alltraps
801063ab:	e9 9a f9 ff ff       	jmp    80105d4a <alltraps>

801063b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $33
801063b2:	6a 21                	push   $0x21
  jmp alltraps
801063b4:	e9 91 f9 ff ff       	jmp    80105d4a <alltraps>

801063b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $34
801063bb:	6a 22                	push   $0x22
  jmp alltraps
801063bd:	e9 88 f9 ff ff       	jmp    80105d4a <alltraps>

801063c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $35
801063c4:	6a 23                	push   $0x23
  jmp alltraps
801063c6:	e9 7f f9 ff ff       	jmp    80105d4a <alltraps>

801063cb <vector36>:
.globl vector36
vector36:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $36
801063cd:	6a 24                	push   $0x24
  jmp alltraps
801063cf:	e9 76 f9 ff ff       	jmp    80105d4a <alltraps>

801063d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $37
801063d6:	6a 25                	push   $0x25
  jmp alltraps
801063d8:	e9 6d f9 ff ff       	jmp    80105d4a <alltraps>

801063dd <vector38>:
.globl vector38
vector38:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $38
801063df:	6a 26                	push   $0x26
  jmp alltraps
801063e1:	e9 64 f9 ff ff       	jmp    80105d4a <alltraps>

801063e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $39
801063e8:	6a 27                	push   $0x27
  jmp alltraps
801063ea:	e9 5b f9 ff ff       	jmp    80105d4a <alltraps>

801063ef <vector40>:
.globl vector40
vector40:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $40
801063f1:	6a 28                	push   $0x28
  jmp alltraps
801063f3:	e9 52 f9 ff ff       	jmp    80105d4a <alltraps>

801063f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $41
801063fa:	6a 29                	push   $0x29
  jmp alltraps
801063fc:	e9 49 f9 ff ff       	jmp    80105d4a <alltraps>

80106401 <vector42>:
.globl vector42
vector42:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $42
80106403:	6a 2a                	push   $0x2a
  jmp alltraps
80106405:	e9 40 f9 ff ff       	jmp    80105d4a <alltraps>

8010640a <vector43>:
.globl vector43
vector43:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $43
8010640c:	6a 2b                	push   $0x2b
  jmp alltraps
8010640e:	e9 37 f9 ff ff       	jmp    80105d4a <alltraps>

80106413 <vector44>:
.globl vector44
vector44:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $44
80106415:	6a 2c                	push   $0x2c
  jmp alltraps
80106417:	e9 2e f9 ff ff       	jmp    80105d4a <alltraps>

8010641c <vector45>:
.globl vector45
vector45:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $45
8010641e:	6a 2d                	push   $0x2d
  jmp alltraps
80106420:	e9 25 f9 ff ff       	jmp    80105d4a <alltraps>

80106425 <vector46>:
.globl vector46
vector46:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $46
80106427:	6a 2e                	push   $0x2e
  jmp alltraps
80106429:	e9 1c f9 ff ff       	jmp    80105d4a <alltraps>

8010642e <vector47>:
.globl vector47
vector47:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $47
80106430:	6a 2f                	push   $0x2f
  jmp alltraps
80106432:	e9 13 f9 ff ff       	jmp    80105d4a <alltraps>

80106437 <vector48>:
.globl vector48
vector48:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $48
80106439:	6a 30                	push   $0x30
  jmp alltraps
8010643b:	e9 0a f9 ff ff       	jmp    80105d4a <alltraps>

80106440 <vector49>:
.globl vector49
vector49:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $49
80106442:	6a 31                	push   $0x31
  jmp alltraps
80106444:	e9 01 f9 ff ff       	jmp    80105d4a <alltraps>

80106449 <vector50>:
.globl vector50
vector50:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $50
8010644b:	6a 32                	push   $0x32
  jmp alltraps
8010644d:	e9 f8 f8 ff ff       	jmp    80105d4a <alltraps>

80106452 <vector51>:
.globl vector51
vector51:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $51
80106454:	6a 33                	push   $0x33
  jmp alltraps
80106456:	e9 ef f8 ff ff       	jmp    80105d4a <alltraps>

8010645b <vector52>:
.globl vector52
vector52:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $52
8010645d:	6a 34                	push   $0x34
  jmp alltraps
8010645f:	e9 e6 f8 ff ff       	jmp    80105d4a <alltraps>

80106464 <vector53>:
.globl vector53
vector53:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $53
80106466:	6a 35                	push   $0x35
  jmp alltraps
80106468:	e9 dd f8 ff ff       	jmp    80105d4a <alltraps>

8010646d <vector54>:
.globl vector54
vector54:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $54
8010646f:	6a 36                	push   $0x36
  jmp alltraps
80106471:	e9 d4 f8 ff ff       	jmp    80105d4a <alltraps>

80106476 <vector55>:
.globl vector55
vector55:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $55
80106478:	6a 37                	push   $0x37
  jmp alltraps
8010647a:	e9 cb f8 ff ff       	jmp    80105d4a <alltraps>

8010647f <vector56>:
.globl vector56
vector56:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $56
80106481:	6a 38                	push   $0x38
  jmp alltraps
80106483:	e9 c2 f8 ff ff       	jmp    80105d4a <alltraps>

80106488 <vector57>:
.globl vector57
vector57:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $57
8010648a:	6a 39                	push   $0x39
  jmp alltraps
8010648c:	e9 b9 f8 ff ff       	jmp    80105d4a <alltraps>

80106491 <vector58>:
.globl vector58
vector58:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $58
80106493:	6a 3a                	push   $0x3a
  jmp alltraps
80106495:	e9 b0 f8 ff ff       	jmp    80105d4a <alltraps>

8010649a <vector59>:
.globl vector59
vector59:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $59
8010649c:	6a 3b                	push   $0x3b
  jmp alltraps
8010649e:	e9 a7 f8 ff ff       	jmp    80105d4a <alltraps>

801064a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $60
801064a5:	6a 3c                	push   $0x3c
  jmp alltraps
801064a7:	e9 9e f8 ff ff       	jmp    80105d4a <alltraps>

801064ac <vector61>:
.globl vector61
vector61:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $61
801064ae:	6a 3d                	push   $0x3d
  jmp alltraps
801064b0:	e9 95 f8 ff ff       	jmp    80105d4a <alltraps>

801064b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $62
801064b7:	6a 3e                	push   $0x3e
  jmp alltraps
801064b9:	e9 8c f8 ff ff       	jmp    80105d4a <alltraps>

801064be <vector63>:
.globl vector63
vector63:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $63
801064c0:	6a 3f                	push   $0x3f
  jmp alltraps
801064c2:	e9 83 f8 ff ff       	jmp    80105d4a <alltraps>

801064c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $64
801064c9:	6a 40                	push   $0x40
  jmp alltraps
801064cb:	e9 7a f8 ff ff       	jmp    80105d4a <alltraps>

801064d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $65
801064d2:	6a 41                	push   $0x41
  jmp alltraps
801064d4:	e9 71 f8 ff ff       	jmp    80105d4a <alltraps>

801064d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $66
801064db:	6a 42                	push   $0x42
  jmp alltraps
801064dd:	e9 68 f8 ff ff       	jmp    80105d4a <alltraps>

801064e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $67
801064e4:	6a 43                	push   $0x43
  jmp alltraps
801064e6:	e9 5f f8 ff ff       	jmp    80105d4a <alltraps>

801064eb <vector68>:
.globl vector68
vector68:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $68
801064ed:	6a 44                	push   $0x44
  jmp alltraps
801064ef:	e9 56 f8 ff ff       	jmp    80105d4a <alltraps>

801064f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $69
801064f6:	6a 45                	push   $0x45
  jmp alltraps
801064f8:	e9 4d f8 ff ff       	jmp    80105d4a <alltraps>

801064fd <vector70>:
.globl vector70
vector70:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $70
801064ff:	6a 46                	push   $0x46
  jmp alltraps
80106501:	e9 44 f8 ff ff       	jmp    80105d4a <alltraps>

80106506 <vector71>:
.globl vector71
vector71:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $71
80106508:	6a 47                	push   $0x47
  jmp alltraps
8010650a:	e9 3b f8 ff ff       	jmp    80105d4a <alltraps>

8010650f <vector72>:
.globl vector72
vector72:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $72
80106511:	6a 48                	push   $0x48
  jmp alltraps
80106513:	e9 32 f8 ff ff       	jmp    80105d4a <alltraps>

80106518 <vector73>:
.globl vector73
vector73:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $73
8010651a:	6a 49                	push   $0x49
  jmp alltraps
8010651c:	e9 29 f8 ff ff       	jmp    80105d4a <alltraps>

80106521 <vector74>:
.globl vector74
vector74:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $74
80106523:	6a 4a                	push   $0x4a
  jmp alltraps
80106525:	e9 20 f8 ff ff       	jmp    80105d4a <alltraps>

8010652a <vector75>:
.globl vector75
vector75:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $75
8010652c:	6a 4b                	push   $0x4b
  jmp alltraps
8010652e:	e9 17 f8 ff ff       	jmp    80105d4a <alltraps>

80106533 <vector76>:
.globl vector76
vector76:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $76
80106535:	6a 4c                	push   $0x4c
  jmp alltraps
80106537:	e9 0e f8 ff ff       	jmp    80105d4a <alltraps>

8010653c <vector77>:
.globl vector77
vector77:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $77
8010653e:	6a 4d                	push   $0x4d
  jmp alltraps
80106540:	e9 05 f8 ff ff       	jmp    80105d4a <alltraps>

80106545 <vector78>:
.globl vector78
vector78:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $78
80106547:	6a 4e                	push   $0x4e
  jmp alltraps
80106549:	e9 fc f7 ff ff       	jmp    80105d4a <alltraps>

8010654e <vector79>:
.globl vector79
vector79:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $79
80106550:	6a 4f                	push   $0x4f
  jmp alltraps
80106552:	e9 f3 f7 ff ff       	jmp    80105d4a <alltraps>

80106557 <vector80>:
.globl vector80
vector80:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $80
80106559:	6a 50                	push   $0x50
  jmp alltraps
8010655b:	e9 ea f7 ff ff       	jmp    80105d4a <alltraps>

80106560 <vector81>:
.globl vector81
vector81:
  pushl $0
80106560:	6a 00                	push   $0x0
  pushl $81
80106562:	6a 51                	push   $0x51
  jmp alltraps
80106564:	e9 e1 f7 ff ff       	jmp    80105d4a <alltraps>

80106569 <vector82>:
.globl vector82
vector82:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $82
8010656b:	6a 52                	push   $0x52
  jmp alltraps
8010656d:	e9 d8 f7 ff ff       	jmp    80105d4a <alltraps>

80106572 <vector83>:
.globl vector83
vector83:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $83
80106574:	6a 53                	push   $0x53
  jmp alltraps
80106576:	e9 cf f7 ff ff       	jmp    80105d4a <alltraps>

8010657b <vector84>:
.globl vector84
vector84:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $84
8010657d:	6a 54                	push   $0x54
  jmp alltraps
8010657f:	e9 c6 f7 ff ff       	jmp    80105d4a <alltraps>

80106584 <vector85>:
.globl vector85
vector85:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $85
80106586:	6a 55                	push   $0x55
  jmp alltraps
80106588:	e9 bd f7 ff ff       	jmp    80105d4a <alltraps>

8010658d <vector86>:
.globl vector86
vector86:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $86
8010658f:	6a 56                	push   $0x56
  jmp alltraps
80106591:	e9 b4 f7 ff ff       	jmp    80105d4a <alltraps>

80106596 <vector87>:
.globl vector87
vector87:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $87
80106598:	6a 57                	push   $0x57
  jmp alltraps
8010659a:	e9 ab f7 ff ff       	jmp    80105d4a <alltraps>

8010659f <vector88>:
.globl vector88
vector88:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $88
801065a1:	6a 58                	push   $0x58
  jmp alltraps
801065a3:	e9 a2 f7 ff ff       	jmp    80105d4a <alltraps>

801065a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $89
801065aa:	6a 59                	push   $0x59
  jmp alltraps
801065ac:	e9 99 f7 ff ff       	jmp    80105d4a <alltraps>

801065b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $90
801065b3:	6a 5a                	push   $0x5a
  jmp alltraps
801065b5:	e9 90 f7 ff ff       	jmp    80105d4a <alltraps>

801065ba <vector91>:
.globl vector91
vector91:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $91
801065bc:	6a 5b                	push   $0x5b
  jmp alltraps
801065be:	e9 87 f7 ff ff       	jmp    80105d4a <alltraps>

801065c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $92
801065c5:	6a 5c                	push   $0x5c
  jmp alltraps
801065c7:	e9 7e f7 ff ff       	jmp    80105d4a <alltraps>

801065cc <vector93>:
.globl vector93
vector93:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $93
801065ce:	6a 5d                	push   $0x5d
  jmp alltraps
801065d0:	e9 75 f7 ff ff       	jmp    80105d4a <alltraps>

801065d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $94
801065d7:	6a 5e                	push   $0x5e
  jmp alltraps
801065d9:	e9 6c f7 ff ff       	jmp    80105d4a <alltraps>

801065de <vector95>:
.globl vector95
vector95:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $95
801065e0:	6a 5f                	push   $0x5f
  jmp alltraps
801065e2:	e9 63 f7 ff ff       	jmp    80105d4a <alltraps>

801065e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $96
801065e9:	6a 60                	push   $0x60
  jmp alltraps
801065eb:	e9 5a f7 ff ff       	jmp    80105d4a <alltraps>

801065f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $97
801065f2:	6a 61                	push   $0x61
  jmp alltraps
801065f4:	e9 51 f7 ff ff       	jmp    80105d4a <alltraps>

801065f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $98
801065fb:	6a 62                	push   $0x62
  jmp alltraps
801065fd:	e9 48 f7 ff ff       	jmp    80105d4a <alltraps>

80106602 <vector99>:
.globl vector99
vector99:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $99
80106604:	6a 63                	push   $0x63
  jmp alltraps
80106606:	e9 3f f7 ff ff       	jmp    80105d4a <alltraps>

8010660b <vector100>:
.globl vector100
vector100:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $100
8010660d:	6a 64                	push   $0x64
  jmp alltraps
8010660f:	e9 36 f7 ff ff       	jmp    80105d4a <alltraps>

80106614 <vector101>:
.globl vector101
vector101:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $101
80106616:	6a 65                	push   $0x65
  jmp alltraps
80106618:	e9 2d f7 ff ff       	jmp    80105d4a <alltraps>

8010661d <vector102>:
.globl vector102
vector102:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $102
8010661f:	6a 66                	push   $0x66
  jmp alltraps
80106621:	e9 24 f7 ff ff       	jmp    80105d4a <alltraps>

80106626 <vector103>:
.globl vector103
vector103:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $103
80106628:	6a 67                	push   $0x67
  jmp alltraps
8010662a:	e9 1b f7 ff ff       	jmp    80105d4a <alltraps>

8010662f <vector104>:
.globl vector104
vector104:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $104
80106631:	6a 68                	push   $0x68
  jmp alltraps
80106633:	e9 12 f7 ff ff       	jmp    80105d4a <alltraps>

80106638 <vector105>:
.globl vector105
vector105:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $105
8010663a:	6a 69                	push   $0x69
  jmp alltraps
8010663c:	e9 09 f7 ff ff       	jmp    80105d4a <alltraps>

80106641 <vector106>:
.globl vector106
vector106:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $106
80106643:	6a 6a                	push   $0x6a
  jmp alltraps
80106645:	e9 00 f7 ff ff       	jmp    80105d4a <alltraps>

8010664a <vector107>:
.globl vector107
vector107:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $107
8010664c:	6a 6b                	push   $0x6b
  jmp alltraps
8010664e:	e9 f7 f6 ff ff       	jmp    80105d4a <alltraps>

80106653 <vector108>:
.globl vector108
vector108:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $108
80106655:	6a 6c                	push   $0x6c
  jmp alltraps
80106657:	e9 ee f6 ff ff       	jmp    80105d4a <alltraps>

8010665c <vector109>:
.globl vector109
vector109:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $109
8010665e:	6a 6d                	push   $0x6d
  jmp alltraps
80106660:	e9 e5 f6 ff ff       	jmp    80105d4a <alltraps>

80106665 <vector110>:
.globl vector110
vector110:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $110
80106667:	6a 6e                	push   $0x6e
  jmp alltraps
80106669:	e9 dc f6 ff ff       	jmp    80105d4a <alltraps>

8010666e <vector111>:
.globl vector111
vector111:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $111
80106670:	6a 6f                	push   $0x6f
  jmp alltraps
80106672:	e9 d3 f6 ff ff       	jmp    80105d4a <alltraps>

80106677 <vector112>:
.globl vector112
vector112:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $112
80106679:	6a 70                	push   $0x70
  jmp alltraps
8010667b:	e9 ca f6 ff ff       	jmp    80105d4a <alltraps>

80106680 <vector113>:
.globl vector113
vector113:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $113
80106682:	6a 71                	push   $0x71
  jmp alltraps
80106684:	e9 c1 f6 ff ff       	jmp    80105d4a <alltraps>

80106689 <vector114>:
.globl vector114
vector114:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $114
8010668b:	6a 72                	push   $0x72
  jmp alltraps
8010668d:	e9 b8 f6 ff ff       	jmp    80105d4a <alltraps>

80106692 <vector115>:
.globl vector115
vector115:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $115
80106694:	6a 73                	push   $0x73
  jmp alltraps
80106696:	e9 af f6 ff ff       	jmp    80105d4a <alltraps>

8010669b <vector116>:
.globl vector116
vector116:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $116
8010669d:	6a 74                	push   $0x74
  jmp alltraps
8010669f:	e9 a6 f6 ff ff       	jmp    80105d4a <alltraps>

801066a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $117
801066a6:	6a 75                	push   $0x75
  jmp alltraps
801066a8:	e9 9d f6 ff ff       	jmp    80105d4a <alltraps>

801066ad <vector118>:
.globl vector118
vector118:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $118
801066af:	6a 76                	push   $0x76
  jmp alltraps
801066b1:	e9 94 f6 ff ff       	jmp    80105d4a <alltraps>

801066b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $119
801066b8:	6a 77                	push   $0x77
  jmp alltraps
801066ba:	e9 8b f6 ff ff       	jmp    80105d4a <alltraps>

801066bf <vector120>:
.globl vector120
vector120:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $120
801066c1:	6a 78                	push   $0x78
  jmp alltraps
801066c3:	e9 82 f6 ff ff       	jmp    80105d4a <alltraps>

801066c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $121
801066ca:	6a 79                	push   $0x79
  jmp alltraps
801066cc:	e9 79 f6 ff ff       	jmp    80105d4a <alltraps>

801066d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $122
801066d3:	6a 7a                	push   $0x7a
  jmp alltraps
801066d5:	e9 70 f6 ff ff       	jmp    80105d4a <alltraps>

801066da <vector123>:
.globl vector123
vector123:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $123
801066dc:	6a 7b                	push   $0x7b
  jmp alltraps
801066de:	e9 67 f6 ff ff       	jmp    80105d4a <alltraps>

801066e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $124
801066e5:	6a 7c                	push   $0x7c
  jmp alltraps
801066e7:	e9 5e f6 ff ff       	jmp    80105d4a <alltraps>

801066ec <vector125>:
.globl vector125
vector125:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $125
801066ee:	6a 7d                	push   $0x7d
  jmp alltraps
801066f0:	e9 55 f6 ff ff       	jmp    80105d4a <alltraps>

801066f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $126
801066f7:	6a 7e                	push   $0x7e
  jmp alltraps
801066f9:	e9 4c f6 ff ff       	jmp    80105d4a <alltraps>

801066fe <vector127>:
.globl vector127
vector127:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $127
80106700:	6a 7f                	push   $0x7f
  jmp alltraps
80106702:	e9 43 f6 ff ff       	jmp    80105d4a <alltraps>

80106707 <vector128>:
.globl vector128
vector128:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $128
80106709:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010670e:	e9 37 f6 ff ff       	jmp    80105d4a <alltraps>

80106713 <vector129>:
.globl vector129
vector129:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $129
80106715:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010671a:	e9 2b f6 ff ff       	jmp    80105d4a <alltraps>

8010671f <vector130>:
.globl vector130
vector130:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $130
80106721:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106726:	e9 1f f6 ff ff       	jmp    80105d4a <alltraps>

8010672b <vector131>:
.globl vector131
vector131:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $131
8010672d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106732:	e9 13 f6 ff ff       	jmp    80105d4a <alltraps>

80106737 <vector132>:
.globl vector132
vector132:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $132
80106739:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010673e:	e9 07 f6 ff ff       	jmp    80105d4a <alltraps>

80106743 <vector133>:
.globl vector133
vector133:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $133
80106745:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010674a:	e9 fb f5 ff ff       	jmp    80105d4a <alltraps>

8010674f <vector134>:
.globl vector134
vector134:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $134
80106751:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106756:	e9 ef f5 ff ff       	jmp    80105d4a <alltraps>

8010675b <vector135>:
.globl vector135
vector135:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $135
8010675d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106762:	e9 e3 f5 ff ff       	jmp    80105d4a <alltraps>

80106767 <vector136>:
.globl vector136
vector136:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $136
80106769:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010676e:	e9 d7 f5 ff ff       	jmp    80105d4a <alltraps>

80106773 <vector137>:
.globl vector137
vector137:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $137
80106775:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010677a:	e9 cb f5 ff ff       	jmp    80105d4a <alltraps>

8010677f <vector138>:
.globl vector138
vector138:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $138
80106781:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106786:	e9 bf f5 ff ff       	jmp    80105d4a <alltraps>

8010678b <vector139>:
.globl vector139
vector139:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $139
8010678d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106792:	e9 b3 f5 ff ff       	jmp    80105d4a <alltraps>

80106797 <vector140>:
.globl vector140
vector140:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $140
80106799:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010679e:	e9 a7 f5 ff ff       	jmp    80105d4a <alltraps>

801067a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $141
801067a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801067aa:	e9 9b f5 ff ff       	jmp    80105d4a <alltraps>

801067af <vector142>:
.globl vector142
vector142:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $142
801067b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801067b6:	e9 8f f5 ff ff       	jmp    80105d4a <alltraps>

801067bb <vector143>:
.globl vector143
vector143:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $143
801067bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067c2:	e9 83 f5 ff ff       	jmp    80105d4a <alltraps>

801067c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $144
801067c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067ce:	e9 77 f5 ff ff       	jmp    80105d4a <alltraps>

801067d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $145
801067d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067da:	e9 6b f5 ff ff       	jmp    80105d4a <alltraps>

801067df <vector146>:
.globl vector146
vector146:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $146
801067e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067e6:	e9 5f f5 ff ff       	jmp    80105d4a <alltraps>

801067eb <vector147>:
.globl vector147
vector147:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $147
801067ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067f2:	e9 53 f5 ff ff       	jmp    80105d4a <alltraps>

801067f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $148
801067f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067fe:	e9 47 f5 ff ff       	jmp    80105d4a <alltraps>

80106803 <vector149>:
.globl vector149
vector149:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $149
80106805:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010680a:	e9 3b f5 ff ff       	jmp    80105d4a <alltraps>

8010680f <vector150>:
.globl vector150
vector150:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $150
80106811:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106816:	e9 2f f5 ff ff       	jmp    80105d4a <alltraps>

8010681b <vector151>:
.globl vector151
vector151:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $151
8010681d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106822:	e9 23 f5 ff ff       	jmp    80105d4a <alltraps>

80106827 <vector152>:
.globl vector152
vector152:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $152
80106829:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010682e:	e9 17 f5 ff ff       	jmp    80105d4a <alltraps>

80106833 <vector153>:
.globl vector153
vector153:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $153
80106835:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010683a:	e9 0b f5 ff ff       	jmp    80105d4a <alltraps>

8010683f <vector154>:
.globl vector154
vector154:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $154
80106841:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106846:	e9 ff f4 ff ff       	jmp    80105d4a <alltraps>

8010684b <vector155>:
.globl vector155
vector155:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $155
8010684d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106852:	e9 f3 f4 ff ff       	jmp    80105d4a <alltraps>

80106857 <vector156>:
.globl vector156
vector156:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $156
80106859:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010685e:	e9 e7 f4 ff ff       	jmp    80105d4a <alltraps>

80106863 <vector157>:
.globl vector157
vector157:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $157
80106865:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010686a:	e9 db f4 ff ff       	jmp    80105d4a <alltraps>

8010686f <vector158>:
.globl vector158
vector158:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $158
80106871:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106876:	e9 cf f4 ff ff       	jmp    80105d4a <alltraps>

8010687b <vector159>:
.globl vector159
vector159:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $159
8010687d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106882:	e9 c3 f4 ff ff       	jmp    80105d4a <alltraps>

80106887 <vector160>:
.globl vector160
vector160:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $160
80106889:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010688e:	e9 b7 f4 ff ff       	jmp    80105d4a <alltraps>

80106893 <vector161>:
.globl vector161
vector161:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $161
80106895:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010689a:	e9 ab f4 ff ff       	jmp    80105d4a <alltraps>

8010689f <vector162>:
.globl vector162
vector162:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $162
801068a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801068a6:	e9 9f f4 ff ff       	jmp    80105d4a <alltraps>

801068ab <vector163>:
.globl vector163
vector163:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $163
801068ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801068b2:	e9 93 f4 ff ff       	jmp    80105d4a <alltraps>

801068b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $164
801068b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801068be:	e9 87 f4 ff ff       	jmp    80105d4a <alltraps>

801068c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $165
801068c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068ca:	e9 7b f4 ff ff       	jmp    80105d4a <alltraps>

801068cf <vector166>:
.globl vector166
vector166:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $166
801068d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068d6:	e9 6f f4 ff ff       	jmp    80105d4a <alltraps>

801068db <vector167>:
.globl vector167
vector167:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $167
801068dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068e2:	e9 63 f4 ff ff       	jmp    80105d4a <alltraps>

801068e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $168
801068e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068ee:	e9 57 f4 ff ff       	jmp    80105d4a <alltraps>

801068f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $169
801068f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068fa:	e9 4b f4 ff ff       	jmp    80105d4a <alltraps>

801068ff <vector170>:
.globl vector170
vector170:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $170
80106901:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106906:	e9 3f f4 ff ff       	jmp    80105d4a <alltraps>

8010690b <vector171>:
.globl vector171
vector171:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $171
8010690d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106912:	e9 33 f4 ff ff       	jmp    80105d4a <alltraps>

80106917 <vector172>:
.globl vector172
vector172:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $172
80106919:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010691e:	e9 27 f4 ff ff       	jmp    80105d4a <alltraps>

80106923 <vector173>:
.globl vector173
vector173:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $173
80106925:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010692a:	e9 1b f4 ff ff       	jmp    80105d4a <alltraps>

8010692f <vector174>:
.globl vector174
vector174:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $174
80106931:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106936:	e9 0f f4 ff ff       	jmp    80105d4a <alltraps>

8010693b <vector175>:
.globl vector175
vector175:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $175
8010693d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106942:	e9 03 f4 ff ff       	jmp    80105d4a <alltraps>

80106947 <vector176>:
.globl vector176
vector176:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $176
80106949:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010694e:	e9 f7 f3 ff ff       	jmp    80105d4a <alltraps>

80106953 <vector177>:
.globl vector177
vector177:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $177
80106955:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010695a:	e9 eb f3 ff ff       	jmp    80105d4a <alltraps>

8010695f <vector178>:
.globl vector178
vector178:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $178
80106961:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106966:	e9 df f3 ff ff       	jmp    80105d4a <alltraps>

8010696b <vector179>:
.globl vector179
vector179:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $179
8010696d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106972:	e9 d3 f3 ff ff       	jmp    80105d4a <alltraps>

80106977 <vector180>:
.globl vector180
vector180:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $180
80106979:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010697e:	e9 c7 f3 ff ff       	jmp    80105d4a <alltraps>

80106983 <vector181>:
.globl vector181
vector181:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $181
80106985:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010698a:	e9 bb f3 ff ff       	jmp    80105d4a <alltraps>

8010698f <vector182>:
.globl vector182
vector182:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $182
80106991:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106996:	e9 af f3 ff ff       	jmp    80105d4a <alltraps>

8010699b <vector183>:
.globl vector183
vector183:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $183
8010699d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801069a2:	e9 a3 f3 ff ff       	jmp    80105d4a <alltraps>

801069a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $184
801069a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801069ae:	e9 97 f3 ff ff       	jmp    80105d4a <alltraps>

801069b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $185
801069b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801069ba:	e9 8b f3 ff ff       	jmp    80105d4a <alltraps>

801069bf <vector186>:
.globl vector186
vector186:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $186
801069c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069c6:	e9 7f f3 ff ff       	jmp    80105d4a <alltraps>

801069cb <vector187>:
.globl vector187
vector187:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $187
801069cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069d2:	e9 73 f3 ff ff       	jmp    80105d4a <alltraps>

801069d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $188
801069d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069de:	e9 67 f3 ff ff       	jmp    80105d4a <alltraps>

801069e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $189
801069e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069ea:	e9 5b f3 ff ff       	jmp    80105d4a <alltraps>

801069ef <vector190>:
.globl vector190
vector190:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $190
801069f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069f6:	e9 4f f3 ff ff       	jmp    80105d4a <alltraps>

801069fb <vector191>:
.globl vector191
vector191:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $191
801069fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a02:	e9 43 f3 ff ff       	jmp    80105d4a <alltraps>

80106a07 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $192
80106a09:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a0e:	e9 37 f3 ff ff       	jmp    80105d4a <alltraps>

80106a13 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $193
80106a15:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a1a:	e9 2b f3 ff ff       	jmp    80105d4a <alltraps>

80106a1f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $194
80106a21:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a26:	e9 1f f3 ff ff       	jmp    80105d4a <alltraps>

80106a2b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $195
80106a2d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a32:	e9 13 f3 ff ff       	jmp    80105d4a <alltraps>

80106a37 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $196
80106a39:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a3e:	e9 07 f3 ff ff       	jmp    80105d4a <alltraps>

80106a43 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $197
80106a45:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a4a:	e9 fb f2 ff ff       	jmp    80105d4a <alltraps>

80106a4f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $198
80106a51:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a56:	e9 ef f2 ff ff       	jmp    80105d4a <alltraps>

80106a5b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $199
80106a5d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a62:	e9 e3 f2 ff ff       	jmp    80105d4a <alltraps>

80106a67 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $200
80106a69:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a6e:	e9 d7 f2 ff ff       	jmp    80105d4a <alltraps>

80106a73 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $201
80106a75:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a7a:	e9 cb f2 ff ff       	jmp    80105d4a <alltraps>

80106a7f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $202
80106a81:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a86:	e9 bf f2 ff ff       	jmp    80105d4a <alltraps>

80106a8b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $203
80106a8d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a92:	e9 b3 f2 ff ff       	jmp    80105d4a <alltraps>

80106a97 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $204
80106a99:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a9e:	e9 a7 f2 ff ff       	jmp    80105d4a <alltraps>

80106aa3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $205
80106aa5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106aaa:	e9 9b f2 ff ff       	jmp    80105d4a <alltraps>

80106aaf <vector206>:
.globl vector206
vector206:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $206
80106ab1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ab6:	e9 8f f2 ff ff       	jmp    80105d4a <alltraps>

80106abb <vector207>:
.globl vector207
vector207:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $207
80106abd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ac2:	e9 83 f2 ff ff       	jmp    80105d4a <alltraps>

80106ac7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $208
80106ac9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ace:	e9 77 f2 ff ff       	jmp    80105d4a <alltraps>

80106ad3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $209
80106ad5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106ada:	e9 6b f2 ff ff       	jmp    80105d4a <alltraps>

80106adf <vector210>:
.globl vector210
vector210:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $210
80106ae1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ae6:	e9 5f f2 ff ff       	jmp    80105d4a <alltraps>

80106aeb <vector211>:
.globl vector211
vector211:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $211
80106aed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106af2:	e9 53 f2 ff ff       	jmp    80105d4a <alltraps>

80106af7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $212
80106af9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106afe:	e9 47 f2 ff ff       	jmp    80105d4a <alltraps>

80106b03 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $213
80106b05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b0a:	e9 3b f2 ff ff       	jmp    80105d4a <alltraps>

80106b0f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $214
80106b11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b16:	e9 2f f2 ff ff       	jmp    80105d4a <alltraps>

80106b1b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $215
80106b1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b22:	e9 23 f2 ff ff       	jmp    80105d4a <alltraps>

80106b27 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $216
80106b29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b2e:	e9 17 f2 ff ff       	jmp    80105d4a <alltraps>

80106b33 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $217
80106b35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b3a:	e9 0b f2 ff ff       	jmp    80105d4a <alltraps>

80106b3f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $218
80106b41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b46:	e9 ff f1 ff ff       	jmp    80105d4a <alltraps>

80106b4b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $219
80106b4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b52:	e9 f3 f1 ff ff       	jmp    80105d4a <alltraps>

80106b57 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $220
80106b59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b5e:	e9 e7 f1 ff ff       	jmp    80105d4a <alltraps>

80106b63 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $221
80106b65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b6a:	e9 db f1 ff ff       	jmp    80105d4a <alltraps>

80106b6f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $222
80106b71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b76:	e9 cf f1 ff ff       	jmp    80105d4a <alltraps>

80106b7b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $223
80106b7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b82:	e9 c3 f1 ff ff       	jmp    80105d4a <alltraps>

80106b87 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $224
80106b89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b8e:	e9 b7 f1 ff ff       	jmp    80105d4a <alltraps>

80106b93 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $225
80106b95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b9a:	e9 ab f1 ff ff       	jmp    80105d4a <alltraps>

80106b9f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $226
80106ba1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ba6:	e9 9f f1 ff ff       	jmp    80105d4a <alltraps>

80106bab <vector227>:
.globl vector227
vector227:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $227
80106bad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106bb2:	e9 93 f1 ff ff       	jmp    80105d4a <alltraps>

80106bb7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $228
80106bb9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106bbe:	e9 87 f1 ff ff       	jmp    80105d4a <alltraps>

80106bc3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $229
80106bc5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106bca:	e9 7b f1 ff ff       	jmp    80105d4a <alltraps>

80106bcf <vector230>:
.globl vector230
vector230:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $230
80106bd1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106bd6:	e9 6f f1 ff ff       	jmp    80105d4a <alltraps>

80106bdb <vector231>:
.globl vector231
vector231:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $231
80106bdd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106be2:	e9 63 f1 ff ff       	jmp    80105d4a <alltraps>

80106be7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $232
80106be9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bee:	e9 57 f1 ff ff       	jmp    80105d4a <alltraps>

80106bf3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $233
80106bf5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106bfa:	e9 4b f1 ff ff       	jmp    80105d4a <alltraps>

80106bff <vector234>:
.globl vector234
vector234:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $234
80106c01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c06:	e9 3f f1 ff ff       	jmp    80105d4a <alltraps>

80106c0b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $235
80106c0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c12:	e9 33 f1 ff ff       	jmp    80105d4a <alltraps>

80106c17 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $236
80106c19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c1e:	e9 27 f1 ff ff       	jmp    80105d4a <alltraps>

80106c23 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $237
80106c25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c2a:	e9 1b f1 ff ff       	jmp    80105d4a <alltraps>

80106c2f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $238
80106c31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c36:	e9 0f f1 ff ff       	jmp    80105d4a <alltraps>

80106c3b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $239
80106c3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c42:	e9 03 f1 ff ff       	jmp    80105d4a <alltraps>

80106c47 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $240
80106c49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c4e:	e9 f7 f0 ff ff       	jmp    80105d4a <alltraps>

80106c53 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $241
80106c55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c5a:	e9 eb f0 ff ff       	jmp    80105d4a <alltraps>

80106c5f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $242
80106c61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c66:	e9 df f0 ff ff       	jmp    80105d4a <alltraps>

80106c6b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $243
80106c6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c72:	e9 d3 f0 ff ff       	jmp    80105d4a <alltraps>

80106c77 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $244
80106c79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c7e:	e9 c7 f0 ff ff       	jmp    80105d4a <alltraps>

80106c83 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $245
80106c85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c8a:	e9 bb f0 ff ff       	jmp    80105d4a <alltraps>

80106c8f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $246
80106c91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c96:	e9 af f0 ff ff       	jmp    80105d4a <alltraps>

80106c9b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $247
80106c9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ca2:	e9 a3 f0 ff ff       	jmp    80105d4a <alltraps>

80106ca7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $248
80106ca9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106cae:	e9 97 f0 ff ff       	jmp    80105d4a <alltraps>

80106cb3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $249
80106cb5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106cba:	e9 8b f0 ff ff       	jmp    80105d4a <alltraps>

80106cbf <vector250>:
.globl vector250
vector250:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $250
80106cc1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106cc6:	e9 7f f0 ff ff       	jmp    80105d4a <alltraps>

80106ccb <vector251>:
.globl vector251
vector251:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $251
80106ccd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106cd2:	e9 73 f0 ff ff       	jmp    80105d4a <alltraps>

80106cd7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $252
80106cd9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cde:	e9 67 f0 ff ff       	jmp    80105d4a <alltraps>

80106ce3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $253
80106ce5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cea:	e9 5b f0 ff ff       	jmp    80105d4a <alltraps>

80106cef <vector254>:
.globl vector254
vector254:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $254
80106cf1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106cf6:	e9 4f f0 ff ff       	jmp    80105d4a <alltraps>

80106cfb <vector255>:
.globl vector255
vector255:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $255
80106cfd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d02:	e9 43 f0 ff ff       	jmp    80105d4a <alltraps>
80106d07:	66 90                	xchg   %ax,%ax
80106d09:	66 90                	xchg   %ax,%ax
80106d0b:	66 90                	xchg   %ax,%ax
80106d0d:	66 90                	xchg   %ax,%ax
80106d0f:	90                   	nop

80106d10 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106d16:	89 d3                	mov    %edx,%ebx
{
80106d18:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106d1a:	c1 eb 16             	shr    $0x16,%ebx
80106d1d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106d20:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106d23:	8b 06                	mov    (%esi),%eax
80106d25:	a8 01                	test   $0x1,%al
80106d27:	74 27                	je     80106d50 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d2e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d34:	c1 ef 0a             	shr    $0xa,%edi
}
80106d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106d3a:	89 fa                	mov    %edi,%edx
80106d3c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d42:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106d45:	5b                   	pop    %ebx
80106d46:	5e                   	pop    %esi
80106d47:	5f                   	pop    %edi
80106d48:	5d                   	pop    %ebp
80106d49:	c3                   	ret    
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d50:	85 c9                	test   %ecx,%ecx
80106d52:	74 2c                	je     80106d80 <walkpgdir+0x70>
80106d54:	e8 67 b7 ff ff       	call   801024c0 <kalloc>
80106d59:	85 c0                	test   %eax,%eax
80106d5b:	89 c3                	mov    %eax,%ebx
80106d5d:	74 21                	je     80106d80 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106d5f:	83 ec 04             	sub    $0x4,%esp
80106d62:	68 00 10 00 00       	push   $0x1000
80106d67:	6a 00                	push   $0x0
80106d69:	50                   	push   %eax
80106d6a:	e8 01 dd ff ff       	call   80104a70 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d6f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d75:	83 c4 10             	add    $0x10,%esp
80106d78:	83 c8 07             	or     $0x7,%eax
80106d7b:	89 06                	mov    %eax,(%esi)
80106d7d:	eb b5                	jmp    80106d34 <walkpgdir+0x24>
80106d7f:	90                   	nop
}
80106d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106d83:	31 c0                	xor    %eax,%eax
}
80106d85:	5b                   	pop    %ebx
80106d86:	5e                   	pop    %esi
80106d87:	5f                   	pop    %edi
80106d88:	5d                   	pop    %ebp
80106d89:	c3                   	ret    
80106d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d90 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d96:	89 d3                	mov    %edx,%ebx
80106d98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d9e:	83 ec 1c             	sub    $0x1c,%esp
80106da1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106da4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106da8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106dab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106db0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106db3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106db6:	29 df                	sub    %ebx,%edi
80106db8:	83 c8 01             	or     $0x1,%eax
80106dbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106dbe:	eb 15                	jmp    80106dd5 <mappages+0x45>
    if(*pte & PTE_P)
80106dc0:	f6 00 01             	testb  $0x1,(%eax)
80106dc3:	75 45                	jne    80106e0a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106dc5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106dc8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106dcb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dcd:	74 31                	je     80106e00 <mappages+0x70>
      break;
    a += PGSIZE;
80106dcf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dd8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106ddd:	89 da                	mov    %ebx,%edx
80106ddf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106de2:	e8 29 ff ff ff       	call   80106d10 <walkpgdir>
80106de7:	85 c0                	test   %eax,%eax
80106de9:	75 d5                	jne    80106dc0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106dee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106df3:	5b                   	pop    %ebx
80106df4:	5e                   	pop    %esi
80106df5:	5f                   	pop    %edi
80106df6:	5d                   	pop    %ebp
80106df7:	c3                   	ret    
80106df8:	90                   	nop
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e03:	31 c0                	xor    %eax,%eax
}
80106e05:	5b                   	pop    %ebx
80106e06:	5e                   	pop    %esi
80106e07:	5f                   	pop    %edi
80106e08:	5d                   	pop    %ebp
80106e09:	c3                   	ret    
      panic("remap");
80106e0a:	83 ec 0c             	sub    $0xc,%esp
80106e0d:	68 b8 7f 10 80       	push   $0x80107fb8
80106e12:	e8 79 95 ff ff       	call   80100390 <panic>
80106e17:	89 f6                	mov    %esi,%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e2c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106e2e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e34:	83 ec 1c             	sub    $0x1c,%esp
80106e37:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e3a:	39 d3                	cmp    %edx,%ebx
80106e3c:	73 66                	jae    80106ea4 <deallocuvm.part.0+0x84>
80106e3e:	89 d6                	mov    %edx,%esi
80106e40:	eb 3d                	jmp    80106e7f <deallocuvm.part.0+0x5f>
80106e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e48:	8b 10                	mov    (%eax),%edx
80106e4a:	f6 c2 01             	test   $0x1,%dl
80106e4d:	74 26                	je     80106e75 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e4f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e55:	74 58                	je     80106eaf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e57:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106e5a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106e63:	52                   	push   %edx
80106e64:	e8 a7 b4 ff ff       	call   80102310 <kfree>
      *pte = 0;
80106e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e6c:	83 c4 10             	add    $0x10,%esp
80106e6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106e75:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e7b:	39 f3                	cmp    %esi,%ebx
80106e7d:	73 25                	jae    80106ea4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e7f:	31 c9                	xor    %ecx,%ecx
80106e81:	89 da                	mov    %ebx,%edx
80106e83:	89 f8                	mov    %edi,%eax
80106e85:	e8 86 fe ff ff       	call   80106d10 <walkpgdir>
    if(!pte)
80106e8a:	85 c0                	test   %eax,%eax
80106e8c:	75 ba                	jne    80106e48 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e8e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e94:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106e9a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ea0:	39 f3                	cmp    %esi,%ebx
80106ea2:	72 db                	jb     80106e7f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106ea4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eaa:	5b                   	pop    %ebx
80106eab:	5e                   	pop    %esi
80106eac:	5f                   	pop    %edi
80106ead:	5d                   	pop    %ebp
80106eae:	c3                   	ret    
        panic("kfree");
80106eaf:	83 ec 0c             	sub    $0xc,%esp
80106eb2:	68 a6 78 10 80       	push   $0x801078a6
80106eb7:	e8 d4 94 ff ff       	call   80100390 <panic>
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <seginit>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ec6:	e8 85 c9 ff ff       	call   80103850 <cpuid>
80106ecb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106ed1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ed6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eda:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80106ee1:	ff 00 00 
80106ee4:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
80106eeb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eee:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80106ef5:	ff 00 00 
80106ef8:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80106eff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f02:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80106f09:	ff 00 00 
80106f0c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80106f13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f16:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80106f1d:	ff 00 00 
80106f20:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80106f27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f2a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80106f2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f33:	c1 e8 10             	shr    $0x10,%eax
80106f36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f3d:	0f 01 10             	lgdtl  (%eax)
}
80106f40:	c9                   	leave  
80106f41:	c3                   	ret    
80106f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f50:	a1 e4 6d 11 80       	mov    0x80116de4,%eax
{
80106f55:	55                   	push   %ebp
80106f56:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f58:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f5d:	0f 22 d8             	mov    %eax,%cr3
}
80106f60:	5d                   	pop    %ebp
80106f61:	c3                   	ret    
80106f62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f70 <switchuvm>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 1c             	sub    $0x1c,%esp
80106f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106f7c:	85 db                	test   %ebx,%ebx
80106f7e:	0f 84 cb 00 00 00    	je     8010704f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f84:	8b 43 08             	mov    0x8(%ebx),%eax
80106f87:	85 c0                	test   %eax,%eax
80106f89:	0f 84 da 00 00 00    	je     80107069 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f8f:	8b 43 04             	mov    0x4(%ebx),%eax
80106f92:	85 c0                	test   %eax,%eax
80106f94:	0f 84 c2 00 00 00    	je     8010705c <switchuvm+0xec>
  pushcli();
80106f9a:	e8 f1 d8 ff ff       	call   80104890 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f9f:	e8 3c c8 ff ff       	call   801037e0 <mycpu>
80106fa4:	89 c6                	mov    %eax,%esi
80106fa6:	e8 35 c8 ff ff       	call   801037e0 <mycpu>
80106fab:	89 c7                	mov    %eax,%edi
80106fad:	e8 2e c8 ff ff       	call   801037e0 <mycpu>
80106fb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fb5:	83 c7 08             	add    $0x8,%edi
80106fb8:	e8 23 c8 ff ff       	call   801037e0 <mycpu>
80106fbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fc0:	83 c0 08             	add    $0x8,%eax
80106fc3:	ba 67 00 00 00       	mov    $0x67,%edx
80106fc8:	c1 e8 18             	shr    $0x18,%eax
80106fcb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106fd2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106fd9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fdf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fe4:	83 c1 08             	add    $0x8,%ecx
80106fe7:	c1 e9 10             	shr    $0x10,%ecx
80106fea:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106ff0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ff5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ffc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107001:	e8 da c7 ff ff       	call   801037e0 <mycpu>
80107006:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010700d:	e8 ce c7 ff ff       	call   801037e0 <mycpu>
80107012:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107016:	8b 73 08             	mov    0x8(%ebx),%esi
80107019:	e8 c2 c7 ff ff       	call   801037e0 <mycpu>
8010701e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107024:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107027:	e8 b4 c7 ff ff       	call   801037e0 <mycpu>
8010702c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107030:	b8 28 00 00 00       	mov    $0x28,%eax
80107035:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107038:	8b 43 04             	mov    0x4(%ebx),%eax
8010703b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107040:	0f 22 d8             	mov    %eax,%cr3
}
80107043:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107046:	5b                   	pop    %ebx
80107047:	5e                   	pop    %esi
80107048:	5f                   	pop    %edi
80107049:	5d                   	pop    %ebp
  popcli();
8010704a:	e9 81 d8 ff ff       	jmp    801048d0 <popcli>
    panic("switchuvm: no process");
8010704f:	83 ec 0c             	sub    $0xc,%esp
80107052:	68 be 7f 10 80       	push   $0x80107fbe
80107057:	e8 34 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010705c:	83 ec 0c             	sub    $0xc,%esp
8010705f:	68 e9 7f 10 80       	push   $0x80107fe9
80107064:	e8 27 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107069:	83 ec 0c             	sub    $0xc,%esp
8010706c:	68 d4 7f 10 80       	push   $0x80107fd4
80107071:	e8 1a 93 ff ff       	call   80100390 <panic>
80107076:	8d 76 00             	lea    0x0(%esi),%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <inituvm>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 1c             	sub    $0x1c,%esp
80107089:	8b 75 10             	mov    0x10(%ebp),%esi
8010708c:	8b 45 08             	mov    0x8(%ebp),%eax
8010708f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107092:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010709b:	77 49                	ja     801070e6 <inituvm+0x66>
  mem = kalloc();
8010709d:	e8 1e b4 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
801070a2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801070a5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070a7:	68 00 10 00 00       	push   $0x1000
801070ac:	6a 00                	push   $0x0
801070ae:	50                   	push   %eax
801070af:	e8 bc d9 ff ff       	call   80104a70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070b4:	58                   	pop    %eax
801070b5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070bb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070c0:	5a                   	pop    %edx
801070c1:	6a 06                	push   $0x6
801070c3:	50                   	push   %eax
801070c4:	31 d2                	xor    %edx,%edx
801070c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070c9:	e8 c2 fc ff ff       	call   80106d90 <mappages>
  memmove(mem, init, sz);
801070ce:	89 75 10             	mov    %esi,0x10(%ebp)
801070d1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801070d4:	83 c4 10             	add    $0x10,%esp
801070d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801070da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070dd:	5b                   	pop    %ebx
801070de:	5e                   	pop    %esi
801070df:	5f                   	pop    %edi
801070e0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070e1:	e9 3a da ff ff       	jmp    80104b20 <memmove>
    panic("inituvm: more than a page");
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	68 fd 7f 10 80       	push   $0x80107ffd
801070ee:	e8 9d 92 ff ff       	call   80100390 <panic>
801070f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107100 <loaduvm>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107109:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107110:	0f 85 91 00 00 00    	jne    801071a7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107116:	8b 75 18             	mov    0x18(%ebp),%esi
80107119:	31 db                	xor    %ebx,%ebx
8010711b:	85 f6                	test   %esi,%esi
8010711d:	75 1a                	jne    80107139 <loaduvm+0x39>
8010711f:	eb 6f                	jmp    80107190 <loaduvm+0x90>
80107121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107128:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010712e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107134:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107137:	76 57                	jbe    80107190 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107139:	8b 55 0c             	mov    0xc(%ebp),%edx
8010713c:	8b 45 08             	mov    0x8(%ebp),%eax
8010713f:	31 c9                	xor    %ecx,%ecx
80107141:	01 da                	add    %ebx,%edx
80107143:	e8 c8 fb ff ff       	call   80106d10 <walkpgdir>
80107148:	85 c0                	test   %eax,%eax
8010714a:	74 4e                	je     8010719a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010714c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010714e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107151:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107156:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010715b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107161:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107164:	01 d9                	add    %ebx,%ecx
80107166:	05 00 00 00 80       	add    $0x80000000,%eax
8010716b:	57                   	push   %edi
8010716c:	51                   	push   %ecx
8010716d:	50                   	push   %eax
8010716e:	ff 75 10             	pushl  0x10(%ebp)
80107171:	e8 ea a7 ff ff       	call   80101960 <readi>
80107176:	83 c4 10             	add    $0x10,%esp
80107179:	39 f8                	cmp    %edi,%eax
8010717b:	74 ab                	je     80107128 <loaduvm+0x28>
}
8010717d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107185:	5b                   	pop    %ebx
80107186:	5e                   	pop    %esi
80107187:	5f                   	pop    %edi
80107188:	5d                   	pop    %ebp
80107189:	c3                   	ret    
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107193:	31 c0                	xor    %eax,%eax
}
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
      panic("loaduvm: address should exist");
8010719a:	83 ec 0c             	sub    $0xc,%esp
8010719d:	68 17 80 10 80       	push   $0x80108017
801071a2:	e8 e9 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801071a7:	83 ec 0c             	sub    $0xc,%esp
801071aa:	68 b8 80 10 80       	push   $0x801080b8
801071af:	e8 dc 91 ff ff       	call   80100390 <panic>
801071b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071c0 <allocuvm>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071c9:	8b 7d 10             	mov    0x10(%ebp),%edi
801071cc:	85 ff                	test   %edi,%edi
801071ce:	0f 88 8e 00 00 00    	js     80107262 <allocuvm+0xa2>
  if(newsz < oldsz)
801071d4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801071d7:	0f 82 93 00 00 00    	jb     80107270 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801071dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801071e6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801071ec:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801071ef:	0f 86 7e 00 00 00    	jbe    80107273 <allocuvm+0xb3>
801071f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801071f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801071fb:	eb 42                	jmp    8010723f <allocuvm+0x7f>
801071fd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107200:	83 ec 04             	sub    $0x4,%esp
80107203:	68 00 10 00 00       	push   $0x1000
80107208:	6a 00                	push   $0x0
8010720a:	50                   	push   %eax
8010720b:	e8 60 d8 ff ff       	call   80104a70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107210:	58                   	pop    %eax
80107211:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107217:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010721c:	5a                   	pop    %edx
8010721d:	6a 06                	push   $0x6
8010721f:	50                   	push   %eax
80107220:	89 da                	mov    %ebx,%edx
80107222:	89 f8                	mov    %edi,%eax
80107224:	e8 67 fb ff ff       	call   80106d90 <mappages>
80107229:	83 c4 10             	add    $0x10,%esp
8010722c:	85 c0                	test   %eax,%eax
8010722e:	78 50                	js     80107280 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107230:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107236:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107239:	0f 86 81 00 00 00    	jbe    801072c0 <allocuvm+0x100>
    mem = kalloc();
8010723f:	e8 7c b2 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107244:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107246:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107248:	75 b6                	jne    80107200 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010724a:	83 ec 0c             	sub    $0xc,%esp
8010724d:	68 35 80 10 80       	push   $0x80108035
80107252:	e8 09 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107257:	83 c4 10             	add    $0x10,%esp
8010725a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010725d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107260:	77 6e                	ja     801072d0 <allocuvm+0x110>
}
80107262:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107265:	31 ff                	xor    %edi,%edi
}
80107267:	89 f8                	mov    %edi,%eax
80107269:	5b                   	pop    %ebx
8010726a:	5e                   	pop    %esi
8010726b:	5f                   	pop    %edi
8010726c:	5d                   	pop    %ebp
8010726d:	c3                   	ret    
8010726e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107270:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107273:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107276:	89 f8                	mov    %edi,%eax
80107278:	5b                   	pop    %ebx
80107279:	5e                   	pop    %esi
8010727a:	5f                   	pop    %edi
8010727b:	5d                   	pop    %ebp
8010727c:	c3                   	ret    
8010727d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107280:	83 ec 0c             	sub    $0xc,%esp
80107283:	68 4d 80 10 80       	push   $0x8010804d
80107288:	e8 d3 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010728d:	83 c4 10             	add    $0x10,%esp
80107290:	8b 45 0c             	mov    0xc(%ebp),%eax
80107293:	39 45 10             	cmp    %eax,0x10(%ebp)
80107296:	76 0d                	jbe    801072a5 <allocuvm+0xe5>
80107298:	89 c1                	mov    %eax,%ecx
8010729a:	8b 55 10             	mov    0x10(%ebp),%edx
8010729d:	8b 45 08             	mov    0x8(%ebp),%eax
801072a0:	e8 7b fb ff ff       	call   80106e20 <deallocuvm.part.0>
      kfree(mem);
801072a5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801072a8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801072aa:	56                   	push   %esi
801072ab:	e8 60 b0 ff ff       	call   80102310 <kfree>
      return 0;
801072b0:	83 c4 10             	add    $0x10,%esp
}
801072b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b6:	89 f8                	mov    %edi,%eax
801072b8:	5b                   	pop    %ebx
801072b9:	5e                   	pop    %esi
801072ba:	5f                   	pop    %edi
801072bb:	5d                   	pop    %ebp
801072bc:	c3                   	ret    
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
801072c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801072c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072c6:	5b                   	pop    %ebx
801072c7:	89 f8                	mov    %edi,%eax
801072c9:	5e                   	pop    %esi
801072ca:	5f                   	pop    %edi
801072cb:	5d                   	pop    %ebp
801072cc:	c3                   	ret    
801072cd:	8d 76 00             	lea    0x0(%esi),%esi
801072d0:	89 c1                	mov    %eax,%ecx
801072d2:	8b 55 10             	mov    0x10(%ebp),%edx
801072d5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801072d8:	31 ff                	xor    %edi,%edi
801072da:	e8 41 fb ff ff       	call   80106e20 <deallocuvm.part.0>
801072df:	eb 92                	jmp    80107273 <allocuvm+0xb3>
801072e1:	eb 0d                	jmp    801072f0 <deallocuvm>
801072e3:	90                   	nop
801072e4:	90                   	nop
801072e5:	90                   	nop
801072e6:	90                   	nop
801072e7:	90                   	nop
801072e8:	90                   	nop
801072e9:	90                   	nop
801072ea:	90                   	nop
801072eb:	90                   	nop
801072ec:	90                   	nop
801072ed:	90                   	nop
801072ee:	90                   	nop
801072ef:	90                   	nop

801072f0 <deallocuvm>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801072f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801072f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801072fc:	39 d1                	cmp    %edx,%ecx
801072fe:	73 10                	jae    80107310 <deallocuvm+0x20>
}
80107300:	5d                   	pop    %ebp
80107301:	e9 1a fb ff ff       	jmp    80106e20 <deallocuvm.part.0>
80107306:	8d 76 00             	lea    0x0(%esi),%esi
80107309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107310:	89 d0                	mov    %edx,%eax
80107312:	5d                   	pop    %ebp
80107313:	c3                   	ret    
80107314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010731a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107320 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010732c:	85 f6                	test   %esi,%esi
8010732e:	74 59                	je     80107389 <freevm+0x69>
80107330:	31 c9                	xor    %ecx,%ecx
80107332:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107337:	89 f0                	mov    %esi,%eax
80107339:	e8 e2 fa ff ff       	call   80106e20 <deallocuvm.part.0>
8010733e:	89 f3                	mov    %esi,%ebx
80107340:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107346:	eb 0f                	jmp    80107357 <freevm+0x37>
80107348:	90                   	nop
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107350:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107353:	39 fb                	cmp    %edi,%ebx
80107355:	74 23                	je     8010737a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107357:	8b 03                	mov    (%ebx),%eax
80107359:	a8 01                	test   $0x1,%al
8010735b:	74 f3                	je     80107350 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010735d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107362:	83 ec 0c             	sub    $0xc,%esp
80107365:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107368:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010736d:	50                   	push   %eax
8010736e:	e8 9d af ff ff       	call   80102310 <kfree>
80107373:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107376:	39 fb                	cmp    %edi,%ebx
80107378:	75 dd                	jne    80107357 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010737a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010737d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107380:	5b                   	pop    %ebx
80107381:	5e                   	pop    %esi
80107382:	5f                   	pop    %edi
80107383:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107384:	e9 87 af ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107389:	83 ec 0c             	sub    $0xc,%esp
8010738c:	68 69 80 10 80       	push   $0x80108069
80107391:	e8 fa 8f ff ff       	call   80100390 <panic>
80107396:	8d 76 00             	lea    0x0(%esi),%esi
80107399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073a0 <setupkvm>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	56                   	push   %esi
801073a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073a5:	e8 16 b1 ff ff       	call   801024c0 <kalloc>
801073aa:	85 c0                	test   %eax,%eax
801073ac:	89 c6                	mov    %eax,%esi
801073ae:	74 42                	je     801073f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801073b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073b8:	68 00 10 00 00       	push   $0x1000
801073bd:	6a 00                	push   $0x0
801073bf:	50                   	push   %eax
801073c0:	e8 ab d6 ff ff       	call   80104a70 <memset>
801073c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073cb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073ce:	83 ec 08             	sub    $0x8,%esp
801073d1:	8b 13                	mov    (%ebx),%edx
801073d3:	ff 73 0c             	pushl  0xc(%ebx)
801073d6:	50                   	push   %eax
801073d7:	29 c1                	sub    %eax,%ecx
801073d9:	89 f0                	mov    %esi,%eax
801073db:	e8 b0 f9 ff ff       	call   80106d90 <mappages>
801073e0:	83 c4 10             	add    $0x10,%esp
801073e3:	85 c0                	test   %eax,%eax
801073e5:	78 19                	js     80107400 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073e7:	83 c3 10             	add    $0x10,%ebx
801073ea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801073f0:	75 d6                	jne    801073c8 <setupkvm+0x28>
}
801073f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073f5:	89 f0                	mov    %esi,%eax
801073f7:	5b                   	pop    %ebx
801073f8:	5e                   	pop    %esi
801073f9:	5d                   	pop    %ebp
801073fa:	c3                   	ret    
801073fb:	90                   	nop
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107400:	83 ec 0c             	sub    $0xc,%esp
80107403:	56                   	push   %esi
      return 0;
80107404:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107406:	e8 15 ff ff ff       	call   80107320 <freevm>
      return 0;
8010740b:	83 c4 10             	add    $0x10,%esp
}
8010740e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107411:	89 f0                	mov    %esi,%eax
80107413:	5b                   	pop    %ebx
80107414:	5e                   	pop    %esi
80107415:	5d                   	pop    %ebp
80107416:	c3                   	ret    
80107417:	89 f6                	mov    %esi,%esi
80107419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107420 <kvmalloc>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107426:	e8 75 ff ff ff       	call   801073a0 <setupkvm>
8010742b:	a3 e4 6d 11 80       	mov    %eax,0x80116de4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107430:	05 00 00 00 80       	add    $0x80000000,%eax
80107435:	0f 22 d8             	mov    %eax,%cr3
}
80107438:	c9                   	leave  
80107439:	c3                   	ret    
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107440 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107440:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107441:	31 c9                	xor    %ecx,%ecx
{
80107443:	89 e5                	mov    %esp,%ebp
80107445:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107448:	8b 55 0c             	mov    0xc(%ebp),%edx
8010744b:	8b 45 08             	mov    0x8(%ebp),%eax
8010744e:	e8 bd f8 ff ff       	call   80106d10 <walkpgdir>
  if(pte == 0)
80107453:	85 c0                	test   %eax,%eax
80107455:	74 05                	je     8010745c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107457:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010745a:	c9                   	leave  
8010745b:	c3                   	ret    
    panic("clearpteu");
8010745c:	83 ec 0c             	sub    $0xc,%esp
8010745f:	68 7a 80 10 80       	push   $0x8010807a
80107464:	e8 27 8f ff ff       	call   80100390 <panic>
80107469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107470 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	57                   	push   %edi
80107474:	56                   	push   %esi
80107475:	53                   	push   %ebx
80107476:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107479:	e8 22 ff ff ff       	call   801073a0 <setupkvm>
8010747e:	85 c0                	test   %eax,%eax
80107480:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107483:	0f 84 9f 00 00 00    	je     80107528 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107489:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010748c:	85 c9                	test   %ecx,%ecx
8010748e:	0f 84 94 00 00 00    	je     80107528 <copyuvm+0xb8>
80107494:	31 ff                	xor    %edi,%edi
80107496:	eb 4a                	jmp    801074e2 <copyuvm+0x72>
80107498:	90                   	nop
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074a0:	83 ec 04             	sub    $0x4,%esp
801074a3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801074a9:	68 00 10 00 00       	push   $0x1000
801074ae:	53                   	push   %ebx
801074af:	50                   	push   %eax
801074b0:	e8 6b d6 ff ff       	call   80104b20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074b5:	58                   	pop    %eax
801074b6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801074bc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074c1:	5a                   	pop    %edx
801074c2:	ff 75 e4             	pushl  -0x1c(%ebp)
801074c5:	50                   	push   %eax
801074c6:	89 fa                	mov    %edi,%edx
801074c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074cb:	e8 c0 f8 ff ff       	call   80106d90 <mappages>
801074d0:	83 c4 10             	add    $0x10,%esp
801074d3:	85 c0                	test   %eax,%eax
801074d5:	78 61                	js     80107538 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801074d7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801074dd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801074e0:	76 46                	jbe    80107528 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801074e2:	8b 45 08             	mov    0x8(%ebp),%eax
801074e5:	31 c9                	xor    %ecx,%ecx
801074e7:	89 fa                	mov    %edi,%edx
801074e9:	e8 22 f8 ff ff       	call   80106d10 <walkpgdir>
801074ee:	85 c0                	test   %eax,%eax
801074f0:	74 61                	je     80107553 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801074f2:	8b 00                	mov    (%eax),%eax
801074f4:	a8 01                	test   $0x1,%al
801074f6:	74 4e                	je     80107546 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801074f8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801074fa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801074ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107505:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107508:	e8 b3 af ff ff       	call   801024c0 <kalloc>
8010750d:	85 c0                	test   %eax,%eax
8010750f:	89 c6                	mov    %eax,%esi
80107511:	75 8d                	jne    801074a0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107513:	83 ec 0c             	sub    $0xc,%esp
80107516:	ff 75 e0             	pushl  -0x20(%ebp)
80107519:	e8 02 fe ff ff       	call   80107320 <freevm>
  return 0;
8010751e:	83 c4 10             	add    $0x10,%esp
80107521:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107528:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010752b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010752e:	5b                   	pop    %ebx
8010752f:	5e                   	pop    %esi
80107530:	5f                   	pop    %edi
80107531:	5d                   	pop    %ebp
80107532:	c3                   	ret    
80107533:	90                   	nop
80107534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107538:	83 ec 0c             	sub    $0xc,%esp
8010753b:	56                   	push   %esi
8010753c:	e8 cf ad ff ff       	call   80102310 <kfree>
      goto bad;
80107541:	83 c4 10             	add    $0x10,%esp
80107544:	eb cd                	jmp    80107513 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107546:	83 ec 0c             	sub    $0xc,%esp
80107549:	68 9e 80 10 80       	push   $0x8010809e
8010754e:	e8 3d 8e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107553:	83 ec 0c             	sub    $0xc,%esp
80107556:	68 84 80 10 80       	push   $0x80108084
8010755b:	e8 30 8e ff ff       	call   80100390 <panic>

80107560 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107560:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107561:	31 c9                	xor    %ecx,%ecx
{
80107563:	89 e5                	mov    %esp,%ebp
80107565:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107568:	8b 55 0c             	mov    0xc(%ebp),%edx
8010756b:	8b 45 08             	mov    0x8(%ebp),%eax
8010756e:	e8 9d f7 ff ff       	call   80106d10 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107573:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107575:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107576:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107578:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010757d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107580:	05 00 00 00 80       	add    $0x80000000,%eax
80107585:	83 fa 05             	cmp    $0x5,%edx
80107588:	ba 00 00 00 00       	mov    $0x0,%edx
8010758d:	0f 45 c2             	cmovne %edx,%eax
}
80107590:	c3                   	ret    
80107591:	eb 0d                	jmp    801075a0 <copyout>
80107593:	90                   	nop
80107594:	90                   	nop
80107595:	90                   	nop
80107596:	90                   	nop
80107597:	90                   	nop
80107598:	90                   	nop
80107599:	90                   	nop
8010759a:	90                   	nop
8010759b:	90                   	nop
8010759c:	90                   	nop
8010759d:	90                   	nop
8010759e:	90                   	nop
8010759f:	90                   	nop

801075a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 1c             	sub    $0x1c,%esp
801075a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801075ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801075af:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075b2:	85 db                	test   %ebx,%ebx
801075b4:	75 40                	jne    801075f6 <copyout+0x56>
801075b6:	eb 70                	jmp    80107628 <copyout+0x88>
801075b8:	90                   	nop
801075b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801075c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075c3:	89 f1                	mov    %esi,%ecx
801075c5:	29 d1                	sub    %edx,%ecx
801075c7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801075cd:	39 d9                	cmp    %ebx,%ecx
801075cf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075d2:	29 f2                	sub    %esi,%edx
801075d4:	83 ec 04             	sub    $0x4,%esp
801075d7:	01 d0                	add    %edx,%eax
801075d9:	51                   	push   %ecx
801075da:	57                   	push   %edi
801075db:	50                   	push   %eax
801075dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801075df:	e8 3c d5 ff ff       	call   80104b20 <memmove>
    len -= n;
    buf += n;
801075e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801075e7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801075ea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801075f0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801075f2:	29 cb                	sub    %ecx,%ebx
801075f4:	74 32                	je     80107628 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801075f6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801075f8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801075fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801075fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107604:	56                   	push   %esi
80107605:	ff 75 08             	pushl  0x8(%ebp)
80107608:	e8 53 ff ff ff       	call   80107560 <uva2ka>
    if(pa0 == 0)
8010760d:	83 c4 10             	add    $0x10,%esp
80107610:	85 c0                	test   %eax,%eax
80107612:	75 ac                	jne    801075c0 <copyout+0x20>
  }
  return 0;
}
80107614:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010761c:	5b                   	pop    %ebx
8010761d:	5e                   	pop    %esi
8010761e:	5f                   	pop    %edi
8010761f:	5d                   	pop    %ebp
80107620:	c3                   	ret    
80107621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107628:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010762b:	31 c0                	xor    %eax,%eax
}
8010762d:	5b                   	pop    %ebx
8010762e:	5e                   	pop    %esi
8010762f:	5f                   	pop    %edi
80107630:	5d                   	pop    %ebp
80107631:	c3                   	ret    
