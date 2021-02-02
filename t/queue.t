#!perl
use Test::Most;
my $deeply = \&eq_or_diff;

use List::GroupingPriorityQueue
  qw(grpriq_add grpriq_min grpriq_min_values grpriq_max grpriq_max_values);

my $queue = [];

grpriq_add($queue, 're', 2);
$deeply->($queue, [ [ ['re'], 2 ] ]);

grpriq_add($queue, 'bi', 8);
$deeply->($queue, [ [ ['re'], 2 ], [ ['bi'], 8 ] ]);

grpriq_add($queue, 'no', 0);
$deeply->(
    $queue, [ [ ['no'], 0 ], [ ['re'], 2 ], [ ['bi'], 8 ] ]
);

grpriq_add($queue, 'eight', 8);
$deeply->(
    $queue,
    [ [ ['no'], 0 ], [ ['re'], 2 ], [ [ 'bi', 'eight' ], 8 ] ]
);

grpriq_add($queue, 'zero', 0);
$deeply->(
    $queue,
    [   [ [ 'no', 'zero' ],  0 ],
        [ ['re'],            2 ],
        [ [ 'bi', 'eight' ], 8 ]
    ]
);

grpriq_add($queue, 'pa', 1);
$deeply->(
    $queue,
    [   [ [ 'no', 'zero' ],  0 ],
        [ ['pa'],            1 ],
        [ ['re'],            2 ],
        [ [ 'bi', 'eight' ], 8 ]
    ]
);

grpriq_add($queue, 'mu', 5);
$deeply->(
    $queue,
    [   [ [ 'no', 'zero' ],  0 ],
        [ ['pa'],            1 ],
        [ ['re'],            2 ],
        [ ['mu'],            5 ],
        [ [ 'bi', 'eight' ], 8 ]
    ]
);

grpriq_add($queue, 'five', 5);
$deeply->(
    $queue,
    [   [ [ 'no', 'zero' ],  0 ],
        [ ['pa'],            1 ],
        [ ['re'],            2 ],
        [ [ 'mu', 'five' ],  5 ],
        [ [ 'bi', 'eight' ], 8 ]
    ]
);

$deeply->(grpriq_min($queue),        [ [ 'no', 'zero' ], 0 ]);
$deeply->(grpriq_min_values($queue), ['pa']);
$deeply->(grpriq_max($queue),        [ [ 'bi', 'eight' ], 8 ]);
$deeply->(grpriq_max_values($queue), [ 'mu', 'five' ]);

$queue = [];
is(grpriq_min_values($queue), undef);
is(grpriq_max_values($queue), undef);

# OO
my $pq = List::GroupingPriorityQueue->new;

# this uses the more extensively tested grpriq_add
$pq->insert('cat',   2);
$pq->insert('dog',   4);
$pq->insert('mlatu', 2);
$pq->insert('finpe', 3);
$pq->insert('cribe', 8);
$pq->insert('tirxu', 5);

$deeply->($pq->pop, [qw/cat mlatu/]);
$deeply->($pq->min, [ ['finpe'], 3 ]);
$deeply->($pq->max, [ ['cribe'], 8 ]);

$deeply->($pq->min_values, ['dog']);
$deeply->($pq->max_values, ['tirxu']);

is($pq->min_values, undef);
is($pq->max_values, undef);

done_testing;
